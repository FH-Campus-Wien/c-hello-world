# C Hello World

Ein minimales C-Starterprojekt für Visual Studio Code und die Lehrveranstaltungen der Hochschule Campus Wien.

Das Projekt wird in einem Dev Container ausgeführt. Dadurch stehen auf Windows, macOS und Linux dieselben Werkzeuge zur Verfügung:

- GCC als C-Compiler
- GDB als Debugger
- Make als Build-Werkzeug
- Microsoft C/C++ Extension für IntelliSense und Debugging

Der Container basiert auf einem schlanken Debian-Image und installiert gezielt nur die für den C-Grundlagenkurs benötigte Toolchain. Beim ersten Öffnen wird das Image einmalig erstellt und anschließend lokal wiederverwendet.

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
│   ├── devcontainer.json
│   └── Dockerfile
├── .vscode/
│   ├── extensions.json
│   ├── launch.json
│   └── tasks.json
├── src/
│   └── main.c
├── Makefile
└── README.md
```

## Projekte mit mehreren C-Dateien

Sobald ein Programm größer wird, sollte es in mehrere Module aufgeteilt werden. Ein mögliches Projekt sieht dann so aus:

```text
.
├── include/
│   └── greeting.h
├── src/
│   ├── greeting.c
│   └── main.c
└── Makefile
```

Jede `.c`-Datei ist eine eigene Übersetzungseinheit. Damit daraus ein gemeinsames Programm entsteht, müssen alle `.c`-Dateien kompiliert und anschließend zusammen gelinkt werden.

### Einfache Variante für kleine Projekte

Für wenige Dateien können die Quellen direkt im Makefile aufgelistet werden:

```make
CC := gcc
CPPFLAGS := -Iinclude
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -g
TARGET := build/hello
SOURCES := src/main.c src/greeting.c
HEADERS := include/greeting.h

.PHONY: all build run clean

all: build

build: $(TARGET)

$(TARGET): $(SOURCES) $(HEADERS)
	mkdir -p build
	$(CC) $(CPPFLAGS) $(CFLAGS) $(SOURCES) -o $(TARGET)

run: build
	./$(TARGET)

clean:
	rm -rf build
```

Wird eine weitere Implementierungsdatei ergänzt, muss sie auch in `SOURCES` eingetragen werden:

```make
SOURCES := src/main.c src/greeting.c src/calculator.c
```

Diese einfache Variante übersetzt bei jeder Änderung alle Quelldateien neu. Für kleine Übungsprojekte ist das übersichtlich und normalerweise schnell genug.

## Header-Dateien

Header beschreiben die öffentliche Schnittstelle eines Moduls. Sie enthalten insbesondere Funktionsdeklarationen, Typdefinitionen und Konstanten. Die eigentliche Implementierung gehört in die zugehörige `.c`-Datei.

`include/greeting.h`:

```c
#ifndef GREETING_H
#define GREETING_H

void print_greeting(void);

#endif
```

`src/greeting.c`:

```c
#include "greeting.h"

#include <stdio.h>

void print_greeting(void)
{
    printf("Hello, World!\n");
}
```

`src/main.c`:

```c
#include "greeting.h"

int main(void)
{
    print_greeting();
    return 0;
}
```

Dabei ist Folgendes zu beachten:

- Header werden mit `#include "greeting.h"` eingebunden, aber nicht selbst kompiliert.
- `-Iinclude` teilt dem Präprozessor mit, wo projektspezifische Header liegen.
- Include-Guards wie `#ifndef GREETING_H` verhindern eine mehrfache Verarbeitung desselben Headers.
- Funktionsimplementierungen gehören normalerweise nicht in Header-Dateien.
- Globale Variablen sollten in Headern höchstens mit `extern` deklariert und genau einmal in einer `.c`-Datei definiert werden.
- Jede `.c`-Datei sollte den Header ihres eigenen Moduls einbinden. So erkennt der Compiler abweichende Deklarationen frühzeitig.
- Wird ein Header geändert, müssen alle davon abhängigen Quelldateien neu übersetzt werden.

In der einfachen Makefile-Variante werden die Header deshalb in `HEADERS` eingetragen. Eine Headeränderung baut dadurch sicherheitshalber das gesamte Programm neu.

### Skalierbare Variante mit Objektdateien

Bei größeren Projekten sollte jede `.c`-Datei zunächst in eine eigene Objektdatei übersetzt werden. `-MMD -MP` erzeugt dabei automatisch Abhängigkeitsdateien für verwendete Header:

```make
CC := gcc
CPPFLAGS := -Iinclude
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -g -MMD -MP
TARGET := build/hello
SOURCES := $(wildcard src/*.c)
OBJECTS := $(patsubst src/%.c,build/%.o,$(SOURCES))
DEPENDENCIES := $(OBJECTS:.o=.d)

.PHONY: all build run clean

all: build

build: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@

build/%.o: src/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

run: build
	./$(TARGET)

clean:
	rm -rf build

-include $(DEPENDENCIES)
```

Damit werden nach einer Änderung nur die betroffenen `.c`-Dateien neu kompiliert. Neue Dateien unter `src/` werden durch `wildcard` automatisch berücksichtigt. Für den Einstieg reicht die einfache Variante; Objektdateien und automatische Abhängigkeiten sind der nächste sinnvolle Schritt bei wachsenden Projekten.

## Aufräumen

```bash
make clean
```

## Verantwortlichkeit und Erstellung

**Konzeption, fachliche Verantwortung und Pflege:**

Michael Strommer, Hochschule Campus Wien

Dieses Starterprojekt und seine Dokumentation wurden mit Unterstützung von **OpenAI Codex** umgesetzt. Konfiguration, Build und Inhalte wurden vor der Veröffentlichung technisch und fachlich geprüft.

## Lizenz

Dieses Starterprojekt steht unter der [MIT-Lizenz](LICENSE).
