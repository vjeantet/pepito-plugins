# Issue tracker : markdown local

Les tickets et specs produits par les skills de travail vivent en markdown sous `.scratch/` (versionné). Les issues GitHub du dépôt ne sont pas utilisées pour le suivi ; une issue ouverte par un tiers est recopiée dans un ticket au besoin.

## Conventions

- Un chantier par dossier : `.scratch/<chantier>/`.
- Brouillon de spec : `.scratch/<chantier>/spec.md`. Une spec validée est publiée dans `docs/<nom>.md`.
- Tickets : `.scratch/<chantier>/tickets/NN-slug.md`, numérotés à partir de `01`, un fichier par ticket, jamais un fichier combiné.
- Frontmatter de chaque ticket :

  ```yaml
  ---
  type: task            # research | prototype | grilling | task
  status: open          # open | closed
  assignee:             # vide = non réclamé
  blocked_by: []        # numéros de tickets du même chantier
  triage: needs-triage  # voir triage-labels.md
  ---
  ```

- Blocage hors du dépôt (ticket de pepito, version de Claude Code) : `blocked_by` ne le porte pas ; l'écrire dans une section `## Dépendances hors chantier` du ticket, avec le chemin du ticket bloquant (`script-post-traitement#02` = `.scratch/script-post-traitement/tickets/02-contrat.md` de pepito).
- Échanges : section `## Comments` en bas du fichier, entrées datées.
- Résolution : section `## Resolution`, puis `status: closed`.
- Assets de recherche : `.scratch/<chantier>/research/<nom>.md`, liés depuis le ticket.

## Quand un skill dit « publish to the issue tracker »

Créer `.scratch/<chantier>/tickets/NN-slug.md` (dossier créé au besoin), avec NN = plus grand numéro existant + 1.

## Quand un skill dit « fetch the relevant ticket »

Lire le fichier référencé ; l'utilisateur donne le chemin ou `<chantier>#NN`. Un `#NN` seul, sans chantier, n'a pas de sens dans ce dépôt : demander le chantier.

## Opérations wayfinder

- **Carte** : `.scratch/<chantier>/map.md` (Destination / Notes / Tickets et frontière / Decisions so far / Not yet specified / Out of scope).
- **Ticket enfant** : `tickets/NN-slug.md`, type dans le frontmatter.
- **Blocage** : `blocked_by` ; un ticket est débloqué quand tous ses bloquants sont `closed` et que ses dépendances hors chantier sont levées.
- **Frontière** : tickets `status: open`, `assignee` vide, sans bloquant ouvert, `triage` autre que `needs-info` ; plus petit numéro d'abord.
- **Réclamer** : renseigner `assignee` et sauvegarder avant tout autre travail.
- **Résoudre** : `## Resolution`, `status: closed`, puis une ligne (résumé + lien) dans « Decisions so far » de `map.md`.
