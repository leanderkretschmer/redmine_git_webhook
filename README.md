# Redmine GitHub Webhook Plugin

Dieses Plugin ermöglicht die Integration von GitHub Webhooks in Redmine Tickets.

## Features

- GitHub Tracker für Projekte
- GitHub-Tab in Tickets mit Webhook-Informationen
- Automatische Verarbeitung von GitHub-Events (Commits, Pull Requests, etc.)
- Sichere Webhook-Authentifizierung mit Secret

## Installation

1. Kopieren Sie das Plugin-Verzeichnis nach `plugins/redmine_git_webhook`
2. Führen Sie die Migrationen aus: `rake redmine:plugins:migrate`
3. Starten Sie Redmine neu

## Verwendung

1. Aktivieren Sie den Tracker "GitHub" in Ihrem Projekt
2. Öffnen Sie ein Ticket und gehen Sie zum Tab "GitHub"
3. Kopieren Sie die Webhook-URL und das Secret
4. Konfigurieren Sie den Webhook in GitHub mit diesen Informationen

