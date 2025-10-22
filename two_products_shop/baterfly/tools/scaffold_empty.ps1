# tools/scaffold_all.ps1
param(
  [string]$Root = (Get-Location).Path   # لو حابب تحدد مسار آخر: -Root "C:\path\to\two_products_shop"
)

function Ensure-Dir($p) {
  $d = Join-Path $Root $p
  if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}
function Ensure-File($p, [string]$content = "") {
  $f = Join-Path $Root $p
  $dir = Split-Path $f -Parent
  if (-not (Test-Path $dir)) { Ensure-Dir ($p | Split-Path -Parent) }
  if (-not (Test-Path $f)) {
    if ($p -match '\.png$') { New-Item -ItemType File -Path $f | Out-Null; return }
    $content | Out-File -Encoding UTF8 $f
  }
}

# --- Dirs ---
$dirs = @(
  ".", "web", "lib", "lib/app", "lib/app/assets", "lib/app/assets/fonts", "lib/app/assets/icons",
  "lib/app/assets/images", "lib/app/assets/lottie",
  "lib/app/core", "lib/app/core/config", "lib/app/core/env", "lib/app/core/errors",
  "lib/app/core/network", "lib/app/core/routing", "lib/app/core/theme", "lib/app/core/utils",
  "lib/app/core/widgets", "lib/app/core/widgets/animations", "lib/app/core/widgets/dev",
  "lib/app/domain", "lib/app/domain/entities", "lib/app/domain/repositories",
  "lib/app/domain/usecases", "lib/app/domain/value_objects",
  "lib/app/data", "lib/app/data/datasources", "lib/app/data/datasources/local",
  "lib/app/data/datasources/remote", "lib/app/data/models", "lib/app/data/repositories",
  "lib/app/features", "lib/app/features/catalog", "lib/app/features/catalog/controllers",
  "lib/app/features/catalog/pages", "lib/app/features/catalog/widgets",
  "lib/app/features/product", "lib/app/features/product/controllers",
  "lib/app/features/product/pages", "lib/app/features/product/widgets",
  "lib/app/features/checkout", "lib/app/features/checkout/controllers",
  "lib/app/features/checkout/pages", "lib/app/features/checkout/widgets",
  "lib/app/features/reviews", "lib/app/features/reviews/controllers",
  "lib/app/features/reviews/pages", "lib/app/features/reviews/widgets",
  "lib/app/features/admin", "lib/app/features/admin/auth", "lib/app/features/admin/controllers",
  "lib/app/features/admin/orders", "lib/app/features/admin/pages",
  "lib/app/features/admin/reviews", "lib/app/features/admin/settings",
  "lib/app/features/admin/widgets",
  "lib/app/services", "lib/app/services/analytics", "lib/app/services/notifications",
  "lib/app/services/storage", "lib/app/services/supabase",
  "lib/app/web", "lib/app/web/icons", "lib/app/web/meta",
  "lib/app/test", "lib/app/test/unit", "lib/app/test/widget", "lib/app/test/integration",
  "lib/app/tool", "lib/app/tool/hooks", "lib/app/tool/linters",
  "lib/app/docs", "lib/app/docs/api", "lib/app/docs/decisions", "lib/app/docs/ux",
  "supabase", "supabase/migrations", "supabase/seed", "supabase/policies", "supabase/scripts",
  "supabase/storage", "supabase/storage/product-images",
  "supabase/functions", "supabase/functions/_shared",
  "supabase/functions/create_order", "supabase/functions/submit_review", "supabase/functions/export_orders_csv",
  "deployment", "deployment/netlify", "deployment/vercel", "deployment/nginx",
  "infra", "infra/docker", "infra/monitoring",
  ".github", ".github/workflows",
  "ci", "ci/github", "ci/github/workflows"
)
$dirs | ForEach-Object { Ensure-Dir $_ }

# --- Files (stubs) ---
# جذور
Ensure-File ".gitignore" @"
# Flutter/Dart
.dart_tool/
.packages
build/
.flutter-plugins
.flutter-plugins-dependencies
.melos_tool
pubspec.lock
# Misc
.env
.idea/
.vscode/
"@
Ensure-File "README.md" "# Two Products Shop`n"
Ensure-File ".env.example" "SUPABASE_URL=`nSUPABASE_ANON_KEY=`n"
Ensure-File "pubspec.yaml" @"
name: two_products_shop
description: Two products Flutter Web shop
environment:
  sdk: ">=3.4.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.6.0
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
flutter:
  uses-material-design: true
"@
Ensure-File "analysis_options.yaml" "include: package:flutter_lints/flutter.yaml`n"

# web
Ensure-File "web/index.html" "<!doctype html><html><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'><title>Two Products Shop</title></head><body><script src='flutter.js' defer></script><flt-glass-pane></flt-glass-pane></body></html>"
Ensure-File "web/manifest.json" "{ }"
Ensure-File "web/favicon.png"

# lib basics
Ensure-File "lib/main.dart" @"
import 'package:flutter/material.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/widgets/dev/folder_tree_page.dart';
void main() => runApp(const App());
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const FolderTreePage(),
    );
  }
}
"@

# core/config
Ensure-File "lib/app/core/config/app_constants.dart" "class AppConstants{static const currency='EGP';}"
Ensure-File "lib/app/core/config/app_icons.dart" "import 'package:flutter/material.dart';class AppIcons{static const cart=Icons.shopping_cart_outlined;}"
Ensure-File "lib/app/core/config/app_strings.dart" "class S{static const title='Two Products Shop';}"

# core/env
Ensure-File "lib/app/core/env/env_config.dart" "class EnvConfig{}"
Ensure-File "lib/app/core/env/env_loader.dart" "class Env{static String get url=>const String.fromEnvironment('SUPABASE_URL',defaultValue:'');static String get anonKey=>const String.fromEnvironment('SUPABASE_ANON_KEY',defaultValue:'');}"

# core/errors
Ensure-File "lib/app/core/errors/error_handler.dart" "class ErrorHandler{static T pass<T>(T v)=>v;}"
Ensure-File "lib/app/core/errors/exception_mapper.dart" "class ExceptionMapper{static String msg(Object e)=>e.toString();}"
Ensure-File "lib/app/core/errors/failure.dart" "class Failure{final String message;Failure(this.message);} "

# core/network
Ensure-File "lib/app/core/network/network_checker.dart" "class NetworkChecker{Future<bool> get online async=>true;}"

# core/routing
Ensure-File "lib/app/core/routing/app_router.dart" "class AppRouter{}"
Ensure-File "lib/app/core/routing/app_routes.dart" "class Routes{static const home='/';}"

# core/theme
Ensure-File "lib/app/core/theme/app_colors.dart" "import 'package:flutter/material.dart';class AppColors{static const primary=Colors.teal;}"
Ensure-File "lib/app/core/theme/app_text_styles.dart" "import 'package:flutter/material.dart';class Txt{static const h6=TextStyle(fontSize:16,fontWeight:FontWeight.w600);} "
Ensure-File "lib/app/core/theme/app_theme.dart" "import 'package:flutter/material.dart';class AppTheme{static ThemeData get light=>ThemeData(useMaterial3:true,colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal));}"

# core/utils
Ensure-File "lib/app/core/utils/device_info.dart" "class DeviceInfo{}"
Ensure-File "lib/app/core/utils/formatters.dart" "class Fmt{static String price(num v)=>v.toStringAsFixed(2);} "
Ensure-File "lib/app/core/utils/image_loader.dart" "import 'package:flutter/widgets.dart';class Img extends StatelessWidget{final String url;const Img(this.url,{super.key});@override Widget build(BuildContext c)=>Image.network(url,fit:BoxFit.cover);} "
Ensure-File "lib/app/core/utils/logger.dart" "class Log{static void d(Object o)=>print(o);} "
Ensure-File "lib/app/core/utils/session.dart" "class SessionStore{}"
Ensure-File "lib/app/core/utils/validators.dart" "class Validators{static bool phone(String v)=>RegExp(r'^\+?[0-9]{8,15}$').hasMatch(v);} "

# core/widgets common
Ensure-File "lib/app/core/widgets/app_button.dart" "import 'package:flutter/material.dart';class AppButton extends StatelessWidget{final String text;final VoidCallback? onPressed;const AppButton({super.key,required this.text,this.onPressed});@override Widget build(BuildContext c)=>FilledButton(onPressed:onPressed, child: Text(text));}"
Ensure-File "lib/app/core/widgets/app_header.dart" "import 'package:flutter/material.dart';class AppHeader extends StatelessWidget{final String title;const AppHeader(this.title,{super.key});@override Widget build(BuildContext c)=>Text(title,style:Theme.of(c).textTheme.titleLarge);} "
Ensure-File "lib/app/core/widgets/app_logo.dart" "import 'package:flutter/material.dart';class AppLogo extends StatelessWidget{const AppLogo({super.key});@override Widget build(BuildContext c)=>FlutterLogo(size:48);} "
Ensure-File "lib/app/core/widgets/app_shell.dart" "import 'package:flutter/material.dart';class AppShell extends StatelessWidget{final Widget child;const AppShell({super.key,required this.child});@override Widget build(BuildContext c)=>Scaffold(body: SafeArea(child: child)));}"
Ensure-File "lib/app/core/widgets/app_text_field.dart" "import 'package:flutter/material.dart';class AppTextField extends StatelessWidget{final TextEditingController controller;final String hint;const AppTextField({super.key,required this.controller,required this.hint});@override Widget build(BuildContext c)=>TextField(controller:controller,decoration:InputDecoration(hintText:hint));}"
Ensure-File "lib/app/core/widgets/error_view.dart" "import 'package:flutter/material.dart';class ErrorView extends StatelessWidget{final String msg;const ErrorView(this.msg,{super.key});@override Widget build(BuildContext c)=>Center(child:Text(msg));}"
Ensure-File "lib/app/core/widgets/loading_overlay.dart" "import 'package:flutter/material.dart';class LoadingOverlay extends StatelessWidget{final bool loading;final Widget child;const LoadingOverlay({super.key,required this.loading,required this.child});@override Widget build(BuildContext c)=>Stack(children:[child if(!loading) else const SizedBox(), if(loading) const Center(child:CircularProgressIndicator())]);}"
Ensure-File "lib/app/core/widgets/marketing_hero.dart" "import 'package:flutter/material.dart';class MarketingHero extends StatelessWidget{const MarketingHero({super.key});@override Widget build(BuildContext c)=>Container(height:120,alignment:Alignment.center,child:Text('Two Products Shop'));}"

# core/widgets/animations
Ensure-File "lib/app/core/widgets/animations/fade_slide.dart" "import 'package:flutter/material.dart';class FadeSlide extends StatelessWidget{final Widget child;const FadeSlide({super.key,required this.child});@override Widget build(BuildContext c)=>AnimatedSlide(offset:Offset.zero,duration:Duration(milliseconds:200),child:AnimatedOpacity(opacity:1,duration:Duration(milliseconds:200),child:child)));}"
Ensure-File "lib/app/core/widgets/animations/staggered_grid.dart" "class StaggeredGrid{}"

# core/widgets/dev (شجرة مع أنيميشن)
Ensure-File "lib/app/core/widgets/dev/folder_tree.dart" @"
import 'package:flutter/material.dart';
class FsNode{final String name;final bool isDir;final List<FsNode> children;const FsNode(this.name,{this.isDir=true,this.children=const[]});}
class FolderTree extends StatelessWidget{
  final FsNode root; const FolderTree({super.key,required this.root});
  @override Widget build(BuildContext c)=>_Dir(node:root,depth:0);
}
class _Dir extends StatefulWidget{final FsNode node;final int depth;const _Dir({required this.node,required this.depth});@override State<_Dir> createState()=>_DirState();}
class _DirState extends State<_Dir>{bool open=true;@override Widget build(BuildContext c){
  final n=widget.node;final hasKids=n.children.isNotEmpty;
  return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    InkWell(onTap: n.isDir&&hasKids?()=>setState(()=>open=!open):null, child: Row(children:[
      SizedBox(width: widget.depth*14), if(n.isDir&&hasKids) AnimatedRotation(turns: open?.25:0,duration:Duration(milliseconds:180),child:Icon(Icons.chevron_right,size:18)) else SizedBox(width:18),
      SizedBox(width:6), Icon(n.isDir?Icons.folder:Icons.insert_drive_file,size:18,color:n.isDir?Colors.amber[700]:null), SizedBox(width:6),
      Expanded(child: Text(n.name,overflow:TextOverflow.ellipsis)),
    ])),
    AnimatedCrossFade(duration:Duration(milliseconds:200),crossFadeState: open?CrossFadeState.showSecond:CrossFadeState.showFirst,
      firstChild:SizedBox.shrink(), secondChild: Padding(padding:EdgeInsets.only(top:4),child:Column(children:n.children.map((c)=>_Dir(node:c,depth:widget.depth+1)).toList()))),
  ]);}
}
"@
Ensure-File "lib/app/core/widgets/dev/folder_tree_data.dart" "import 'folder_tree.dart'; const fsRoot=FsNode('two_products_shop',children:[FsNode('lib',children:[FsNode('app',children:[FsNode('...')])])]);"
Ensure-File "lib/app/core/widgets/dev/folder_tree_page.dart" 

# domain
Ensure-File "lib/app/domain/entities/product.dart" "class Product{final int id;final String name;final String slug;final double price;final List<String> images;final String? usage;final List<String> features;final double avgRating;final int reviewsCount;const Product({required this.id,required this.name,required this.slug,required this.price,required this.images,this.usage,this.features=const[],this.avgRating=0,this.reviewsCount=0});}"
Ensure-File "lib/app/domain/entities/review.dart" "class Review{final int id;final int productId;final String fullName;final int rating;final String comment;final bool isVerified;final DateTime createdAt;const Review({required this.id,required this.productId,required this.fullName,required this.rating,required this.comment,required this.isVerified,required this.createdAt});}"
Ensure-File "lib/app/domain/repositories/product_repository.dart" "import '../entities/product.dart';abstract class ProductRepository{Future<List<Product>> getPopularProducts({int limit});Future<Product?> getById(String idOrSlug);} "
Ensure-File "lib/app/domain/repositories/review_repository.dart" "import '../entities/review.dart';abstract class ReviewRepository{Future<List<Review>> getProductReviews(int productId);Future<void> submitReview(Review review);} "
Ensure-File "lib/app/domain/usecases/get_products_usecase.dart" "import '../repositories/product_repository.dart';import '../entities/product.dart';class GetProductsUsecase{final ProductRepository repo;const GetProductsUsecase(this.repo);Future<List<Product>> call({int limit=20})=>repo.getPopularProducts(limit:limit);} "
Ensure-File "lib/app/domain/usecases/get_product_by_id_usecase.dart" "import '../repositories/product_repository.dart';import '../entities/product.dart';class GetProductByIdUsecase{final ProductRepository repo;const GetProductByIdUsecase(this.repo);Future<Product?> call(String idOrSlug)=>repo.getById(idOrSlug);} "
Ensure-File "lib/app/domain/usecases/submit_review_usecase.dart" "import '../repositories/review_repository.dart';import '../entities/review.dart';class SubmitReviewUsecase{final ReviewRepository repo;const SubmitReviewUsecase(this.repo);Future<void> call(Review r)=>repo.submitReview(r);} "
Ensure-File "lib/app/domain/value_objects/price.dart" "class Price{final double value;const Price(this.value);} "
Ensure-File "lib/app/domain/value_objects/rating.dart" "class Rating{final int value;const Rating(this.value);} "

# data models
Ensure-File "lib/app/data/models/product_model.dart" "import '../../domain/entities/product.dart';class ProductModel{final int id;final String name;final String slug;final double price;final List<String> images;final String? usage;final List<String> features;final double avgRating;final int reviewsCount;ProductModel({required this.id,required this.name,required this.slug,required this.price,required this.images,this.usage,this.features=const[],this.avgRating=0,this.reviewsCount=0});factory ProductModel.fromMap(Map<String,dynamic> m)=>ProductModel(id:m['id'],name:m['name'],slug:m['slug'],price:(m['price'] as num).toDouble(),images:((m['images'] as List?)??[]).map((e)=>e.toString()).toList(),usage:m['usage'],features:((m['features'] as List?)??[]).map((e)=>e.toString()).toList(),avgRating:(m['avg_rating']??0).toDouble(),reviewsCount:m['reviews_count']??0);Product toEntity()=>Product(id:id,name:name,slug:slug,price:price,images:images,usage:usage,features:features,avgRating:avgRating,reviewsCount:reviewsCount);} "
Ensure-File "lib/app/data/models/review_model.dart" "import '../../domain/entities/review.dart';class ReviewModel{final int id;final int productId;final String fullName;final int rating;final String comment;final bool isVerified;final DateTime createdAt;ReviewModel({required this.id,required this.productId,required this.fullName,required this.rating,required this.comment,required this.isVerified,required this.createdAt});factory ReviewModel.fromMap(Map<String,dynamic> m)=>ReviewModel(id:m['id'],productId:m['product_id'],fullName:m['full_name'],rating:m['rating'],comment:m['comment'],isVerified:m['is_verified']??false,createdAt:DateTime.parse(m['created_at']));Review toEntity()=>Review(id:id,productId:productId,fullName:fullName,rating:rating,comment:comment,isVerified:isVerified,createdAt:createdAt);} "

# data repositories + remotes
Ensure-File "lib/app/data/repositories/product_repository_impl.dart" "import 'package:supabase_flutter/supabase_flutter.dart';import '../../services/supabase/supabase_service.dart';import '../../domain/repositories/product_repository.dart';import '../../domain/entities/product.dart';import '../models/product_model.dart';class ProductRepositoryImpl implements ProductRepository{final SupabaseClient _sb=Supa.client;final String _table='products';@override Future<List<Product>> getPopularProducts({int limit=20}) async{final res=await _sb.from(_table).select().filter('active','eq',true).order('reviews_count',ascending:false).order('avg_rating',ascending:false).limit(limit);return (res as List).map((e)=>ProductModel.fromMap(e).toEntity()).toList();}@override Future<Product?> getById(String idOrSlug) async{final q=_sb.from(_table).select().limit(1);final id=int.tryParse(idOrSlug); if(id!=null){q.filter('id','eq',id);}else{q.filter('slug','eq',idOrSlug);}final res=await q.maybeSingle();if(res==null) return null;return ProductModel.fromMap(res as Map<String,dynamic>).toEntity();}}"
Ensure-File "lib/app/data/repositories/review_repository_impl.dart" "import 'package:supabase_flutter/supabase_flutter.dart';import '../../services/supabase/supabase_service.dart';import '../../domain/repositories/review_repository.dart';import '../../domain/entities/review.dart';import '../models/review_model.dart';class ReviewRepositoryImpl implements ReviewRepository{final SupabaseClient _sb=Supa.client;final String _table='product_reviews';@override Future<List<Review>> getProductReviews(int productId) async{final res=await _sb.from(_table).select().filter('product_id','eq',productId).filter('status','eq','approved').order('created_at',ascending:false);return (res as List).map((e)=>ReviewModel.fromMap(e).toEntity()).toList();}@override Future<void> submitReview(Review r) async{await _sb.from(_table).insert({'product_id':r.productId,'full_name':r.fullName,'rating':r.rating,'comment':r.comment,'is_verified':r.isVerified});}}"
Ensure-File "lib/app/data/datasources/local/local_cache.dart" "class LocalCache{}"
Ensure-File "lib/app/data/datasources/local/cart_storage.dart" "class CartStorage{}"
Ensure-File "lib/app/data/datasources/remote/orders_remote.dart" "class OrdersRemote{}"
Ensure-File "lib/app/data/datasources/remote/products_remote.dart" "import 'package:supabase_flutter/supabase_flutter.dart';import '../../../services/supabase/supabase_service.dart';import '../../models/product_model.dart';class ProductsRemote{final SupabaseClient _sb=Supa.client;final String _table='products';Future<List<ProductModel>> listPopular({int limit=20}) async{final res=await _sb.from(_table).select().filter('active','eq',true).order('reviews_count',ascending:false).order('avg_rating',ascending:false).limit(limit);return (res as List).map((e)=>ProductModel.fromMap(e)).toList();}}"
Ensure-File "lib/app/data/datasources/remote/reviews_remote.dart" "class ReviewsRemote{}"

# features: catalog/product/checkout/reviews/admin
Ensure-File "lib/app/features/catalog/controllers/catalog_controller.dart" "class CatalogController{}"
Ensure-File "lib/app/features/catalog/pages/home_page.dart" 

Ensure-File "lib/app/features/catalog/widgets/product_card.dart" "import 'package:flutter/material.dart';class ProductCard extends StatelessWidget{const ProductCard({super.key});@override Widget build(BuildContext c)=>Card(child:SizedBox(height:120));}"
Ensure-File "lib/app/features/catalog/widgets/product_grid.dart" "class ProductGrid{}"
Ensure-File "lib/app/features/product/controllers/product_controller.dart" "class ProductController{}"
Ensure-File "lib/app/features/product/pages/product_page.dart" "class ProductPage{}"
Ensure-File "lib/app/features/product/pages/product_page_shell.dart" "class ProductShell{}"
Ensure-File "lib/app/features/product/widgets/feature_list.dart" "class FeatureList{}"
Ensure-File "lib/app/features/product/widgets/product_list_item.dart" "class ProductListItem{}"
Ensure-File "lib/app/features/product/widgets/usage_section.dart" "class UsageSection{}"
Ensure-File "lib/app/features/checkout/controllers/checkout_controller.dart" "class CheckoutController{}"
Ensure-File "lib/app/features/checkout/pages/checkout_page.dart" "class CheckoutPage{}"
Ensure-File "lib/app/features/checkout/pages/thank_you_page.dart" "class ThankYouPage{}"
Ensure-File "lib/app/features/checkout/widgets/order_form.dart" "class OrderForm{}"
Ensure-File "lib/app/features/checkout/widgets/order_summary.dart" "class OrderSummary{}"
Ensure-File "lib/app/features/reviews/controllers/review_controller.dart" "class ReviewController{}"
Ensure-File "lib/app/features/reviews/pages/review_page.dart" "class ReviewPage{}"
Ensure-File "lib/app/features/reviews/widgets/review_section.dart" "class ReviewSection{}"
Ensure-File "lib/app/features/reviews/widgets/star_rating.dart" "class StarRating{}"
Ensure-File "lib/app/features/admin/auth/admin_login_page.dart" "class AdminLoginPage{}"
Ensure-File "lib/app/features/admin/controllers/admin_guard_controller.dart" "class AdminGuardController{}"
Ensure-File "lib/app/features/admin/orders/orders_controller.dart" "class OrdersController{}"
Ensure-File "lib/app/features/admin/pages/admin_dashboard_page.dart" "class AdminDashboardPage{}"
Ensure-File "lib/app/features/admin/pages/orders_page.dart" "class OrdersPage{}"
Ensure-File "lib/app/features/admin/pages/reviews_page.dart" "class ReviewsPage{}"
Ensure-File "lib/app/features/admin/pages/settings_page.dart" "class SettingsPage{}"
Ensure-File "lib/app/features/admin/reviews/reviews_controller.dart" "class AdminReviewsController{}"
Ensure-File "lib/app/features/admin/settings/settings_controller.dart" "class AdminSettingsController{}"
Ensure-File "lib/app/features/admin/widgets/admin_gate.dart" "class AdminGate{}"

# services
Ensure-File "lib/app/services/analytics/analytics_service.dart" "class AnalyticsService{}"
Ensure-File "lib/app/services/notifications/notification_service.dart" "class NotificationService{}"
Ensure-File "lib/app/services/storage/storage_service.dart" "class StorageService{}"
Ensure-File "lib/app/services/supabase/supabase_client.dart" "class SupabaseClientHolder{}"
Ensure-File "lib/app/services/supabase/supabase_service.dart" "import 'package:supabase_flutter/supabase_flutter.dart';import '../../core/env/env_loader.dart';class Supa{static SupabaseClient get client=>SupabaseClient(Env.url,Env.anonKey);} "

# web/meta (داخل lib/app/web/meta كما في شجرتك)
Ensure-File "lib/app/web/meta/index.html" "<!-- meta index -->"
Ensure-File "lib/app/web/meta/manifest.json" "{ }"
Ensure-File "lib/app/web/meta/favicon.png"

# tests
Ensure-File "lib/app/test/unit/product_model_test.dart" "void main(){}"
Ensure-File "lib/app/test/widget/home_page_test.dart" "void main(){}"

# docs
Ensure-File "lib/app/docs/ux/folder_tree_page.dart" "// see dev/folder_tree_page.dart"

# supabase functions
Ensure-File "supabase/functions/_shared/types.ts" "// shared types"
Ensure-File "supabase/functions/create_order/index.ts" "// create order"
Ensure-File "supabase/functions/submit_review/index.ts" "// submit review"
Ensure-File "supabase/functions/export_orders_csv/index.ts" "// export orders csv"

# deployment
Ensure-File "deployment/netlify/netlify.toml" "[build]\n  command = \"flutter build web --release\"\n  publish = \"build/web\"\n\n[[redirects]]\nfrom=\"/*\"\nto=\"/index.html\"\nstatus=200\n"
Ensure-File "deployment/vercel/vercel.json" "{ \"version\":2, \"builds\":[{\"src\":\"build/web/**\",\"use\":\"@vercel/static\"}], \"routes\":[{\"src\":\"/(.*)\",\"dest\":\"/index.html\"}] }"
Ensure-File "deployment/nginx/site.conf" "server{listen 80;root /usr/share/nginx/html;index index.html;location / {try_files \$uri /index.html;} }"

# infra
Ensure-File "infra/docker/Dockerfile.web" "FROM nginx:alpine\nCOPY deployment/nginx/site.conf /etc/nginx/conf.d/default.conf\nCOPY build/web/ /usr/share/nginx/html/"
Ensure-File "infra/docker/docker-compose.yml" "version: '3.9'\nservices:\n  web:\n    build:\n      context: .\n      dockerfile: infra/docker/Dockerfile.web\n    ports:\n      - '8080:80'\n"
Ensure-File "infra/monitoring/docker-compose.yml" "version: '3.9'\nservices:\n  prometheus:\n    image: prom/prometheus\n    volumes:\n      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro\n    ports: ['9090:9090']\n  grafana:\n    image: grafana/grafana\n    ports: ['3000:3000']\n    environment:\n      - GF_SECURITY_ADMIN_PASSWORD=admin\n    depends_on: [prometheus]\n"
Ensure-File "infra/monitoring/prometheus.yml" "global:\n  scrape_interval: 15s\nscrape_configs:\n  - job_name: 'nginx'\n    static_configs:\n      - targets: ['host.docker.internal:8080']\n"

# CI
Ensure-File ".github/workflows/flutter-web.yml" "name: Build Flutter Web\non:\n  push:\n    branches: [ main ]\n  workflow_dispatch:\njobs:\n  build:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - uses: subosito/flutter-action@v2\n        with: { flutter-version: '3.24.0' }\n      - run: flutter pub get\n      - run: flutter build web --release\n      - uses: actions/upload-artifact@v4\n        with:\n          name: web-build\n          path: build/web\n"
Ensure-File ".github/workflows/deploy-netlify.yml" "name: Deploy to Netlify\non:\n  workflow_run:\n    workflows: ['Build Flutter Web']\n    types: [completed]\n    branches: [ main ]\n  workflow_dispatch:\njobs:\n  deploy:\n    if: \${{ github.event.workflow_run.conclusion == 'success' || github.event_name == 'workflow_dispatch' }}\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/download-artifact@v4\n        with: { name: web-build, path: build/web }\n      - uses: nwtgck/actions-netlify@v2.0\n        with:\n          publish-dir: './build/web'\n          production-deploy: 'true'\n        env:\n          NETLIFY_AUTH_TOKEN: \${{ secrets.NETLIFY_AUTH_TOKEN }}\n          NETLIFY_SITE_ID: \${{ secrets.NETLIFY_SITE_ID }}\n"
Ensure-File ".github/workflows/deploy-vercel.yml" "name: Deploy to Vercel\non:\n  workflow_run:\n    workflows: ['Build Flutter Web']\n    types: [completed]\n    branches: [ main ]\n  workflow_dispatch:\njobs:\n  deploy:\n    if: \${{ github.event.workflow_run.conclusion == 'success' || github.event_name == 'workflow_dispatch' }}\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/download-artifact@v4\n        with: { name: web-build, path: build/web }\n      - run: npm i -g vercel@latest\n      - run: vercel deploy --prod --yes build/web\n"

Ensure-File "ci/github/workflows/ci.yml" "name: Lint & Test\non:\n  pull_request:\n  push:\n    branches: [ main ]\njobs:\n  analyze-test:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - uses: subosito/flutter-action@v2\n        with: { flutter-version: '3.24.0' }\n      - run: flutter pub get\n      - run: flutter analyze\n      - run: flutter test -r expanded\n"

Write-Host "✅ Scaffolded under $Root"
