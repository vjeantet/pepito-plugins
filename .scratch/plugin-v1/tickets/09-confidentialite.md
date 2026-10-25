---
type: grilling
status: open
assignee:
blocked_by: []
triage: needs-triage
---

# 09: Confidentialité

Carte : [../map.md](../map.md).

## Question

Le contenu des réunions lu par un skill (Transcription, CR, Notes, Participants, Événement) part vers le modèle utilisé par Claude Code, qui peut être en ligne. pepito positionne ce transfert comme visible et à la charge de l'Outil IA (`serveur-mcp-v1.md` § 1, § 5.1 (c), § 5.4 : texte à l'opt-in, Outils IA vus ; aucun indicateur dans le Menu).

Formulations déjà publiées par pepito (politique de confidentialité publique du site, lue le 2026-10-25) :

- « AI tools you connect to it can read your recordings, transcripts, summaries and notes on your Mac, and may send them to their publisher » ;
- « What a connected tool does with this content, including sending it to its publisher, depends on that tool » ;
- les Outils IA connectés « are not SODADI's processors ».

Bornes de pepito à respecter (`CLAUDE.md` de pepito, `transcription-apple.md` § 8.2, `transcription-script.md` § 10.1) : « aucune connexion », « garanti par Apple » et « Works offline » sans réserve sont hors bornes ; un texte qui parle de la transcription sans nommer le Moteur ne promet que ce qui vaut pour tous.

- **README du plugin** : la phrase actuelle (« ce que Claude Code lit… part vers le modèle utilisé par Claude Code ; ce qu'un Outil IA connecté fait de ce contenu… dépend de lui ») suffit-elle ? Nommer Anthropic, les réglages de rétention de Claude Code, le cas d'un modèle sur un fournisseur cloud de l'utilisateur ?
- **Interdits côté plugin** : aucune phrase qui laisse croire que le contenu reste sur le Mac quand un skill tourne ; vérifier que rien dans les skills ne reprend « la transcription se fait sur le Mac » comme une propriété du plugin.
- **Volume** : un skill qui lit `get_transcript` envoie la réunion entière ; le dire, et préférer le CR (ticket 04) ?
- **Exécution non interactive** (Script de post-traitement, ticket 07) : chaque réunion part au modèle sans geste de l'utilisateur ; mise en garde dans le README et l'exemple, alignée sur `script-post-traitement#06` (envoi possible de chaque réunion à un service en ligne, « à rebours du positionnement réseau interne »).
- **Participants** : noms et adresses des participants (Événement) envoyés au modèle ; responsabilité de l'utilisateur vis-à-vis d'eux, déjà dans la politique de pepito (« you are the sole data controller »). Le rappeler ?
- **Données d'autres outils** : un skill qui relie la réunion à d'autres outils envoie aussi leur contenu au modèle, et peut envoyer le contenu de la réunion vers eux (ticket 04).

Skill : `grilling`. HITL : réponses de l'utilisateur seulement.
