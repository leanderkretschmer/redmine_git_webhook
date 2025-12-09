# Installationsanleitung

## Voraussetzungen

- Redmine 6.x
- Ruby 2.7 oder höher
- Rails 5.2 oder höher

## Installation

1. **Plugin kopieren**
   ```bash
   cp -r redmine_git_webhook /path/to/redmine/plugins/
   ```

2. **Abhängigkeiten installieren**
   ```bash
   cd /path/to/redmine
   bundle install
   ```

3. **Datenbank-Migrationen ausführen**
   ```bash
   rake redmine:plugins:migrate RAILS_ENV=production
   ```

4. **Redmine neu starten**
   ```bash
   # Je nach Setup
   touch tmp/restart.txt
   # oder
   systemctl restart redmine
   ```

## Konfiguration

1. **Tracker aktivieren**
   - Gehen Sie zu Ihrem Projekt
   - Öffnen Sie "Einstellungen" > "Tracker"
   - Aktivieren Sie den Tracker "GitHub"

2. **Webhook konfigurieren**
   - Öffnen Sie ein Ticket
   - Gehen Sie zum Tab "GitHub"
   - Klicken Sie auf "Erstellen", um einen Webhook zu erstellen
   - Kopieren Sie die Webhook-URL und das Secret

3. **GitHub Webhook einrichten**
   - Gehen Sie zu Ihrem GitHub Repository
   - Öffnen Sie "Settings" > "Webhooks"
   - Klicken Sie auf "Add webhook"
   - Fügen Sie die Webhook-URL ein
   - Wählen Sie "application/json" als Content-Type
   - Fügen Sie das Secret ein
   - Wählen Sie die gewünschten Events (z.B. "push", "pull_request")

## Verwendung

Nach der Konfiguration werden alle GitHub-Events automatisch als Journal-Einträge in das entsprechende Redmine-Ticket geschrieben.

