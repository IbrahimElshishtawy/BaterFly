# tools/generate_missing_files.ps1
# يشغّل من جذر المشروع two_products_shop
$base = "C:\FlutterProjects\BaterFly_web_App\BaterFly\BaterFly\two_products_shop"

$files = @(
  # core
  "app\lib\core\config\app_config.dart",
  "app\lib\core\env\env_loader.dart",
  "app\lib\core\routing\app_router.dart",
  "app\lib\core\theme\app_theme.dart",

  # domain
  "app\lib\domain\entities\product.dart",
  "app\lib\domain\entities\review.dart",
  "app\lib\domain\repositories\product_repository.dart",
  "app\lib\domain\repositories\review_repository.dart",
  "app\lib\domain\usecases\get_products_usecase.dart",
  "app\lib\domain\usecases\get_product_by_id_usecase.dart",
  "app\lib\domain\usecases\submit_review_usecase.dart",
  "app\lib\domain\value_objects\price.dart",
  "app\lib\domain\value_objects\rating.dart",

  # data
  "app\lib\data\repositories\product_repository_impl.dart",
  "app\lib\data\repositories\review_repository_impl.dart",
  "app\lib\data\datasources\local\local_cache.dart",
  "app\lib\data\datasources\local\cart_storage.dart",

  # features
  "app\lib\features\catalog\widgets\product_grid.dart",
  "app\lib\features\product\controllers\product_controller.dart",
  "app\lib\features\checkout\widgets\order_summary.dart",
  "app\lib\features\checkout\widgets\order_form.dart",
  "app\lib\features\reviews\pages\review_page.dart",
  "app\lib\features\admin\orders\orders_controller.dart",
  "app\lib\features\admin\reviews\reviews_controller.dart",
  "app\lib\features\admin\settings\settings_controller.dart",

  # services
  "app\lib\services\supabase\supabase_service.dart",
  "app\lib\services\storage\storage_helper.dart",
  "app\lib\services\notifications\notification_helper.dart",

  # web/meta
  "app\web\meta\index.html",
  "app\web\meta\manifest.json",
  "app\web\meta\favicon.png",

  # tests
  "app\test\unit\product_model_test.dart",
  "app\test\widget\home_page_test.dart",

  # supabase functions
  "supabase\functions\create_order\index.ts",
  "supabase\functions\submit_review\index.ts",
  "supabase\functions\export_orders_csv\index.ts",
  "supabase\functions\_shared\types.ts",

  # root
  ".env.example",
  "README.md",
  ".gitignore"
)

foreach ($file in $files) {
  $path = Join-Path $base $file
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  if ($file -match "\.dart$") {
    "@// TODO: Implement $(Split-Path $file -Leaf) 
" | Out-File -Encoding UTF8 $path
  }
  elseif ($file -match "\.ts$") {
    "// TODO: Implement $(Split-Path $file -Leaf)" | Out-File -Encoding UTF8 $path
  }
  elseif ($file -match "\.html$") {
    "<!-- TODO: Implement HTML meta -->" | Out-File -Encoding UTF8 $path
  }
  elseif ($file -match "\.json$") {
    "{ }" | Out-File -Encoding UTF8 $path
  }
  elseif ($file -match "\.png$") {
    $null = New-Item -ItemType File $path
  }
  else {
    "" | Out-File -Encoding UTF8 $path
  }
}

Write-Host "✅ كل الملفات الناقصة اتعملت بنجاح في المسار:"
Write-Host $base
