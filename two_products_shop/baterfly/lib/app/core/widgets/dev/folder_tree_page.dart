import 'package:baterfly/app/core/widgets/dev/folder_tree_data.dart';

const fsRoot = FsNode(
  'two_products_shop',
  children: [
    FsNode(
      'lib',
      children: [
        FsNode(
          'app',
          children: [
            FsNode('core'),
            FsNode('data'),
            FsNode('domain'),
            FsNode('features'),
            FsNode('services'),
            FsNode('web'),
          ],
        ),
      ],
    ),
    FsNode('supabase'),
    FsNode('deployment'),
    FsNode('infra'),
    FsNode('.github'),
    FsNode('ci'),
  ],
);
