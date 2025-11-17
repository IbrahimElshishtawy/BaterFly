// services/content_service.dart
import 'package:baterfly/app/data/models/policy_models.dart';
import 'package:baterfly/app/data/models/support_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<PolicyPageModel> getPolicyPage(String slug) async {
    final pageRes = await _client
        .from('policy_pages')
        .select()
        .eq('slug', slug)
        .single();

    final itemsRes = await _client
        .from('policy_items')
        .select()
        .eq('page_slug', slug)
        .order('sort_order', ascending: true);

    final items = (itemsRes as List)
        .map((e) => PolicyItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return PolicyPageModel.fromJson(pageRes as Map<String, dynamic>, items);
  }

  Future<void> updatePolicyPage(PolicyPageModel model) async {
    await _client
        .from('policy_pages')
        .update({
          'main_title': model.mainTitle,
          'intro_text': model.introText,
          'note_text': model.noteText,
        })
        .eq('slug', model.slug);
  }

  Future<void> deletePolicyPage(String slug) async {
    await _client.from('policy_pages').delete().eq('slug', slug);
  }

  Future<void> deletePolicyItem(int id) async {
    await _client.from('policy_items').delete().eq('id', id);
  }

  Future<SupportPageModel> getSupportPage() async {
    final pageRes = await _client
        .from('support_page')
        .select()
        .order('id', ascending: true)
        .limit(1)
        .maybeSingle();

    final contactsRes = await _client
        .from('support_contacts')
        .select()
        .order('sort_order', ascending: true);

    final contacts = (contactsRes as List)
        .map((e) => SupportContactModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SupportPageModel(
      introText: pageRes?['intro_text'] as String?,
      noteText: pageRes?['note_text'] as String?,
      contacts: contacts,
    );
  }

  Future<void> updateSupportPage(SupportPageModel model) async {
    await _client
        .from('support_page')
        .update({'intro_text': model.introText, 'note_text': model.noteText})
        .eq('id', 1);
  }

  Future<void> deleteSupportContact(int id) async {
    await _client.from('support_contacts').delete().eq('id', id);
  }
}
