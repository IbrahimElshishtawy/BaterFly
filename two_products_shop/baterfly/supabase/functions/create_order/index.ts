// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";
import type { OrderPayload } from "../_shared/types.ts";

serve(async (req) => {
  try {
    const url = Deno.env.get("SUPABASE_URL")!;
    const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(url, key);

    const body = (await req.json()) as OrderPayload;
    if (!body?.product_id || !body?.full_name || !body?.phone1 || !body?.address_text) {
      return new Response(JSON.stringify({ error: "missing fields" }), { status: 400 });
    }
    if ((body.full_name?.length ?? 0) < 10) {
      return new Response(JSON.stringify({ error: "invalid full_name" }), { status: 400 });
    }
    if ((body.address_text?.length ?? 0) < 15) {
      return new Response(JSON.stringify({ error: "invalid address" }), { status: 400 });
    }

    const order_no = `ORD-${Date.now()}`;
    const payload: OrderPayload = {
      ...body,
      order_no,
      quantity: body.quantity ?? 1,
      payment_method: body.payment_method ?? "cod",
    };

    const { data, error } = await sb.from("orders").insert(payload).select().single();
    if (error) throw error;

    return new Response(JSON.stringify({ ok: true, order: data }), { headers: { "Content-Type": "application/json" } });
  } catch (e) {
    return new Response(JSON.stringify({ error: e?.message ?? "unknown" }), { status: 500 });
  }
});
