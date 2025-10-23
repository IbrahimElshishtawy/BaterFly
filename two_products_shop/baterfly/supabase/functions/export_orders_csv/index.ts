// deno-lint-ignore-file no-explicit-any
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

function toCSV(rows: any[]): string {
  if (!rows.length) return "id,order_no,full_name,phone1,product_id,quantity,status,created_at\n";
  const headers = Object.keys(rows[0]);
  const lines = [headers.join(",")];
  for (const r of rows) {
    lines.push(headers.map((h) => JSON.stringify(r[h] ?? "")).join(","));
  }
  return lines.join("\n");
}

serve(async () => {
  try {
    const url = Deno.env.get("SUPABASE_URL")!;
    const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(url, key);

    const { data, error } = await sb
      .from("orders")
      .select("id,order_no,full_name,phone1,product_id,quantity,status,created_at")
      .order("created_at", { ascending: false });

    if (error) throw error;

    const csv = toCSV((data ?? []) as any[]);
    return new Response(csv, {
      headers: {
        "Content-Type": "text/csv; charset=utf-8",
        "Content-Disposition": `attachment; filename="orders_${Date.now()}.csv"`,
      },
    });
  } catch (e) {
    return new Response(`error,${e?.message ?? "unknown"}`, { status: 500 });
  }
});
