# Run from project root (same folder that contains 'app')
$Root = $PSScriptRoot
if (-not (Test-Path (Join-Path $Root "app"))) { throw "Project root must contain 'app' folder." }

$files = @(
"app\lib\core\env\env_loader.dart",
"app\lib\domain\entities\product.dart",
"app\lib\domain\entities\review.dart",
"app\lib\domain\repositories\product_repository.dart",
"app\lib\domain\repositories\review_repository.dart",
"app\lib\domain\usecases\get_products_usecase.dart",
"app\lib\domain\usecases\get_product_by_id_usecase.dart",
"app\lib\domain\usecases\submit_review_usecase.dart",
"app\lib\domain\value_objects\price.dart",
"app\lib\domain\value_objects\rating.dart",
"app\lib\data\repositories\product_repository_impl.dart",
"app\lib\data\repositories\review_repository_impl.dart",
"app\lib\data\datasources\local\local_cache.dart",
"app\lib\data\datasources\local\cart_storage.dart",
"app\lib\features\catalog\widgets\product_grid.dart",
"app\lib\features\product\controllers\product_controller.dart",
"app\lib\features\checkout\widgets\order_form.dart",
"app\lib\features\checkout\widgets\order_summary.dart",
"app\lib\features\reviews\pages\review_page.dart",
"app\lib\features\admin\orders\orders_controller.dart",
"app\lib\features\admin\reviews\reviews_controller.dart",
"app\lib\features\admin\settings\settings_controller.dart",
"app\lib\services\supabase\supabase_service.dart",
"app\web\meta\index.html",
"app\web\meta\manifest.json",
"app\web\meta\favicon.png",
"app\test\unit\product_model_test.dart",
"app\test\widget\home_page_test.dart",
"supabase\functions\create_order\index.ts",
"supabase\functions\submit_review\index.ts",
"supabase\functions\export_orders_csv\index.ts",
"supabase\functions\_shared\types.ts"
)

foreach ($rel in $files) {
  $path = Join-Path $Root $rel
  $dir  = Split-Path $path -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  if (Test-Path $path) { continue }

  switch -Regex ($rel) {
    '\.dart$' { "@// TODO: $(Split-Path $rel -Leaf)`r`n" | Out-File -Encoding UTF8 $path }
    '\.ts$'   { "// TODO: $(Split-Path $rel -Leaf)`r`n"   | Out-File -Encoding UTF8 $path }
    '\.html$' { "<!-- TODO -->`r`n"                       | Out-File -Encoding UTF8 $path }
    '\.json$' { "{}`r`n"                                   | Out-File -Encoding UTF8 $path }
    '\.png$'  { New-Item -ItemType File -Path $path | Out-Null }
    default   { "" | Out-File -Encoding UTF8 $path }
  }
}

Write-Host "Generated missing files under $Root"
