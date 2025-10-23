// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

serve(async (req) => {
  try {
    const url = Deno.env.get("SUPABASE_URL")!;
    const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(url, key);

    const b = await req.json() as any;
    if (!b?.product_id || !b?.full_name || !b?.rating || !b?.comment) {
      return new Response(JSON.stringify({ error: "missing fields" }), { status: 400 });
    }
    if (b.comment.length < 20) {
      return new Response(JSON.stringify({ error: "comment too short" }), { status: 400 });
    }

    const { error } = await sb.from("product_reviews").insert({
      product_id: b.product_id,
      full_name: b.full_name,
      rating: b.rating,
      comment: b.comment,
      is_verified: false,
      status: "pending",
    });
    if (error) throw error;

    return new Response(JSON.stringify({ ok: true }), { headers: { "Content-Type": "application/json" } });
  } catch (e) {
    return new Response(JSON.stringify({ error: e?.message ?? "unknown" }), { status: 500 });
  }
});
