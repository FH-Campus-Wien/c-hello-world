# C Hello World

Ein minimales C-Starterprojekt für Visual Studio Code und die Lehrveranstaltungen der Hochschule Campus Wien.

Das Projekt wird in einem Dev Container ausgeführt. Dadurch stehen auf Windows, macOS und Linux dieselben Werkzeuge zur Verfügung:

- GCC als C-Compiler
- GDB als Debugger
- Make als Build-Werkzeug
- Microsoft C/C++ Extension für IntelliSense und Debugging

## Voraussetzungen

- [Visual Studio Code](https://code.visualstudio.com/)
- [C-Lehrumgebung Extension Pack](https://marketplace.visualstudio.com/items?itemName=HochschuleCampusWien.c-lehrumgebung)
- Docker Desktop oder eine kompatible Container-Laufzeit
- unter Windows: WSL 2 mit aktiviertem Docker-Backend

## Projekt starten

1. Dieses Repository klonen oder als ZIP herunterladen.
2. Docker Desktop starten.
3. Den Projektordner in Visual Studio Code öffnen.
4. **Reopen in Container** bestätigen.
5. Warten, bis die Entwicklungsumgebung beim ersten Start eingerichtet wurde.

Falls der Hinweis nicht erscheint, die Befehlspalette öffnen und **Dev Containers: Reopen in Container** ausführen.

## Bauen und ausführen

Über das Terminal:

```bash
make
make run
```

Oder über Visual Studio Code:

- `Strg/Cmd + Umschalt + B` baut das Programm.
- **Terminal → Run Task → C: Programm ausführen** baut und startet es.

Die erwartete Ausgabe lautet:

```text
Hello, World!
```

Das erzeugte Programm liegt unter `build/hello`.

## Debuggen

1. `src/main.c` öffnen.
2. Links neben einer Codezeile einen Breakpoint setzen.
3. `F5` drücken.
4. **C: Hello World debuggen** auswählen, falls Visual Studio Code nach einer Konfiguration fragt.

Vor dem Debugging wird das Programm automatisch mit Debug-Symbolen gebaut.

## Umgebung überprüfen

Im integrierten Terminal sollten diese Befehle funktionieren:

```bash
gcc --version
gdb --version
make --version
```

## Projektstruktur

```text
.
├── .devcontainer/
│   └── devcontainer.json
├── .vscode/
│   ├── extensions.json
│   ├── launch.json
│   └── tasks.json
├── src/
│   └── main.c
├── Makefile
└── README.md
```

## Aufräumen

```bash
make clean
```

## Lizenz

Dieses Starterprojekt steht unter der [MIT-Lizenz](LICENSE).
