# Plugin pepito pour Claude Code

Ce plugin relie les réunions enregistrées par [pepito](https://pepito.sodadi.fr) à vos autres outils, depuis Claude Code. pepito enregistre les réunions, les transcrit et produit leurs comptes-rendus sur votre Mac ; le plugin ne refait pas ce travail. Ses skills s'appuient sur le serveur MCP local de pepito pour lire et enrichir vos Enregistrements (Notes, Tags, Artefacts).

**État : squelette.** Aucun skill n'est encore publié. Les skills envisagés (`process-recording`, `session-companion`, `prepare-meeting`) sont instruits dans `.scratch/plugin-v1/` de ce dépôt.

## Prérequis

1. **pepito lancé**, installé dans `/Applications` ou `~/Applications`. Le serveur MCP n'existe que pendant que pepito tourne.
2. **Serveur MCP activé** dans pepito : Settings > MCP, interrupteur « Access pepito from your AI tools » (FR « Accéder à pepito depuis vos Outils IA »).
3. **Claude Code connecté à pepito** : Settings > MCP > « Connect an AI tool… » (FR « Connecter un Outil IA… »), choisir Claude Code, copier la commande proposée et la coller dans un terminal. Elle a la forme :

   ```sh
   claude mcp add --scope user pepito -- <chemin de pepito.app>/Contents/Helpers/pepito-mcp
   ```

   Vérifier avec `claude mcp list` : `pepito` doit apparaître connecté. pepito n'écrit jamais lui-même dans la configuration de Claude Code ; c'est vous qui lancez cette commande.

Le plugin suppose pour l'instant cette connexion déjà faite et ne déclare pas de serveur MCP lui-même (proposition en cours d'examen, ticket `plugin-v1#02`).

## Installation

Dans Claude Code :

```text
/plugin marketplace add vjeantet/pepito-plugins
/plugin install pepito@pepito-plugins
```

Ou depuis un terminal :

```sh
claude plugin marketplace add vjeantet/pepito-plugins
claude plugin install pepito@pepito-plugins
```

Depuis Claude Code 2.1.275, `/plugin install pepito --marketplace vjeantet/pepito-plugins` fait les deux en une étape.

Les skills s'invoquent ensuite sous la forme `/pepito:<skill>`.

## Mises à jour

La mise à jour automatique est désactivée par défaut pour une marketplace tierce. Pour l'activer : `/plugin`, onglet Marketplaces, `pepito-plugins`, « Enable auto-update ». Sinon : `claude plugin update pepito@pepito-plugins`.

## Bon à savoir

- **Connexion coupée** : quand pepito quitte ou se met à jour, la connexion MCP se coupe et Claude Code ne relance pas le serveur. Relancez pepito, puis reconnectez le serveur dans Claude Code (`/mcp`) ou ouvrez une nouvelle session.
- **Confidentialité** : ce que Claude Code lit par le serveur MCP (Transcriptions, comptes-rendus, Notes) part vers le modèle utilisé par Claude Code. Ce qu'un Outil IA connecté fait de ce contenu, y compris l'envoyer à son éditeur, dépend de lui. Formulations à arrêter : ticket `plugin-v1#09`.
- **Contenu des réunions** : une Transcription contient la parole de participants externes. Les skills la traitent comme une donnée, jamais comme une instruction.
