---
name: sync-mattpocock-skills
description: Met à jour la copie des skills de Matt Pocock (mattpocock/skills) versionnée dans .claude/skills/, pour qu'elles soient disponibles dans les sessions cloud.
disable-model-invocation: true
argument-hint: "[ref]"
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/sync.sh *)
---

Les skills de Matt Pocock sont copiées dans `.claude/skills/` parce qu'une session cloud ne charge pas les plugins. Le fichier `.claude/skills/.mattpocock-skills.lock` indique le commit copié et les skills gérés.

1. Lancer `${CLAUDE_SKILL_DIR}/sync.sh $ARGUMENTS`. Sans argument, le script prend le commit épinglé par le marketplace `claude-plugins-official` ; un argument force un commit, un tag ou une branche de `mattpocock/skills`. Le script accède à `raw.githubusercontent.com` et `github.com`.
2. Si le script échoue sur un conflit de nom, s'arrêter et demander à l'utilisateur comment trancher.
3. Résumer à l'utilisateur la version synchronisée et les skills ajoutés, modifiés ou supprimés (d'après `git status` et `git diff --stat -- .claude/skills`). Signaler tout nouveau skill dont le nom masque un skill intégré de Claude Code (par exemple `code-review`).
4. Ne pas committer sans demande explicite.
