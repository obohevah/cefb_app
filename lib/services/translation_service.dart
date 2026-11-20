import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

/// Centralized Translation Service with instant dictionary for UI keys
/// and on-the-fly Google Translator for dynamic paragraphs.
class TranslationService {
  static final TranslationService instance = TranslationService._();
  TranslationService._();

  final GoogleTranslator _translator = GoogleTranslator();
  final ValueNotifier<String> currentLanguage = ValueNotifier<String>('en');

  // Cache for translated strings to prevent redundant network calls
  final Map<String, Map<String, String>> _cache = {};

  static const String _prefKey = 'selected_language';

  // Common UI words pre-translated for instant zero-latency UI display
  static final Map<String, Map<String, String>> _dictionary = {
    'es': {
      'Home': 'Inicio',
      'About Us': 'Sobre Nosotros',
      'Watch Live': 'Ver en Vivo',
      'Live Service': 'Servicio en Vivo',
      'Previous Videos': 'Videos Anteriores',
      'Our Beliefs': 'Nuestras Creencias',
      'Our President': 'Nuestro Presidente',
      'New Here': 'Nuevo Aquí',
      'First Steps': 'Primeros Pasos',
      'Connect Groups': 'Grupos de Conexión',
      'Kids Ministry': 'Ministerio de Niños',
      'Events': 'Eventos',
      'Giving': 'Ofrendar',
      'Need Prayer?': '¿Necesitas Oración?',
      'Salvation': 'Salvación',
      'Foundation School': 'Escuela de Fundamentos',
      'Photo Gallery': 'Galería de Fotos',
      'I Believe God': 'Yo le Creo a Dios',
      'Contact Us': 'Contáctenos',
      'Plan Your Visit': 'Planifica tu Visita',
      'Submit Prayer Request': 'Enviar Petición de Oración',
      'Service Times': 'Horarios de Servicio',
      'Sunday': 'Domingo',
      'Wednesday': 'Miércoles',
      'LIVE NOW': 'EN VIVO AHORA',
      'Watch with PiP': 'Ver en Modo Flotante (PiP)',
      'Watch Stream': 'Ver Transmisión',
      'More': 'Más',
    },
    'fr': {
      'Home': 'Accueil',
      'About Us': 'À Propos',
      'Watch Live': 'Regarder en Direct',
      'Live Service': 'Service en Direct',
      'Previous Videos': 'Vidéos Précédentes',
      'Our Beliefs': 'Nos Croyances',
      'Our President': 'Notre Président',
      'New Here': 'Nouveau Ici',
      'First Steps': 'Premières Étapes',
      'Connect Groups': 'Groupes de Maison',
      'Kids Ministry': 'Ministère des Enfants',
      'Events': 'Événements',
      'Giving': 'Donner',
      'Need Prayer?': 'Besoin de Prière?',
      'Salvation': 'Salut',
      'Foundation School': 'École Fondamentale',
      'Photo Gallery': 'Galerie Photos',
      'I Believe God': 'Je Crois en Dieu',
      'Contact Us': 'Contactez-Nous',
      'Plan Your Visit': 'Planifiez Votre Visite',
      'Submit Prayer Request': 'Envoyer une Demande de Prière',
      'Service Times': 'Horaires des Cultes',
      'Sunday': 'Dimanche',
      'Wednesday': 'Mercredi',
      'LIVE NOW': 'EN DIRECT',
      'Watch with PiP': 'Regarder en Flottant (PiP)',
      'Watch Stream': 'Voir le Culte',
      'More': 'Plus',
    },
    'pt': {
      'Home': 'Início',
      'About Us': 'Sobre Nós',
      'Watch Live': 'Assistir ao Vivo',
      'Live Service': 'Culto ao Vivo',
      'Previous Videos': 'Vídeos Anteriores',
      'Our Beliefs': 'Nossas Crenças',
      'Our President': 'Nosso Presidente',
      'New Here': 'Novo Por Aqui',
      'First Steps': 'Primeiros Passos',
      'Connect Groups': 'Grupos de Conexão',
      'Kids Ministry': 'Ministério Infantil',
      'Events': 'Eventos',
      'Giving': 'Contribuição',
      'Need Prayer?': 'Precisa de Oração?',
      'Salvation': 'Salvação',
      'Foundation School': 'Escola de Fundamentos',
      'Photo Gallery': 'Galeria de Fotos',
      'I Believe God': 'Eu Creio em Deus',
      'Contact Us': 'Fale Conosco',
      'Plan Your Visit': 'Planeje Sua Visita',
      'Submit Prayer Request': 'Enviar Pedido de Oração',
      'Service Times': 'Horários dos Cultos',
      'Sunday': 'Domingo',
      'Wednesday': 'Quarta-feira',
      'LIVE NOW': 'AO VIVO AGORA',
      'Watch with PiP': 'Assistir em PiP',
      'Watch Stream': 'Ver Transmissão',
      'More': 'Mais',
    },
  };

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString(_prefKey);
      if (lang != null && ['en', 'es', 'fr', 'pt'].contains(lang)) {
        currentLanguage.value = lang;
      }
    } catch (e) {
      debugPrint('Translation init error: $e');
    }
  }

  Future<void> setLanguage(String langCode) async {
    if (currentLanguage.value == langCode) return;
    currentLanguage.value = langCode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, langCode);
    } catch (e) {
      debugPrint('Save language error: $e');
    }
  }

  /// Translate a given text to the current active language
  String translateSync(String text) {
    final lang = currentLanguage.value;
    if (lang == 'en' || text.trim().isEmpty) return text;

    // 1. Check local instant dictionary
    final dict = _dictionary[lang];
    if (dict != null && dict.containsKey(text.trim())) {
      return dict[text.trim()]!;
    }

    // 2. Check cache
    if (_cache[lang] != null && _cache[lang]!.containsKey(text)) {
      return _cache[lang]![text]!;
    }

    return text;
  }

  /// Asynchronously translates longer paragraphs
  Future<String> translateAsync(String text) async {
    final lang = currentLanguage.value;
    if (lang == 'en' || text.trim().isEmpty) return text;

    // Check dictionary
    final dict = _dictionary[lang];
    if (dict != null && dict.containsKey(text.trim())) {
      return dict[text.trim()]!;
    }

    // Check cache
    if (_cache[lang] != null && _cache[lang]!.containsKey(text)) {
      return _cache[lang]![text]!;
    }

    try {
      final result = await _translator.translate(text, to: lang);
      final translated = result.text;
      _cache.putIfAbsent(lang, () => {})[text] = translated;
      return translated;
    } catch (e) {
      debugPrint('Translator error: $e');
      return text;
    }
  }
}
