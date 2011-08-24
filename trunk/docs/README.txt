README - Ruby Beach Water Sports (Lab 4)
Version 4 (2011-08-03)
Skribent: Johannes Keinestam

UPPDATERADE RUBRIKER: INSTRUKTIONER, CHANGES, FELHANTERING, KLASSER, UML.

INSTRUKTIONER:
I Windows-miljö kan programmet köras genom att dubbelklicka på filen main.rb.
Under *nix-miljöer så startas det via terminalen genom kommandot "ruby main.rb".
För att programmet ska kunna köras måste Ruby 1.92 vara installerat (kan fungera
med andra versioner, men det är ej garanterat). Utöver detta måste SQLite3 och
Ruby-gem:et sqlite3-ruby vara installerat.

OM PROJEKTET:
Ruby Beach Water Sports (RBWS) är ett uthyrningssystem för båtar och andra
vattensportartiklar. Syftet med labben är för mig som student att lära mig
använda programmeringsspråket Ruby genom att koda objektorienterat. Programmet
skulle kunna implementeras som ett uthyrningssystem för vilka typer av produkter
som helst. Detta skulle kunna ta sig form som ett onlinesystem eller ett
integrerat system i någon slags uthyrningsterminal.

PROGRAMDESIGN:
RBWS är strukturerat i två mappar: views och data. Data innehåller programmets
datasamligar och logik. Den håller koll på vad för produkter som finns i utbudet
samt utför operationer på dessa (såsom utlåningar och återlämningar). Views är
allt som har med den grafiska representationen, vilket är ett enkelt terminal-
fönster. På grund av denna uppdelning skulle man enkelt kunna byta ut detta mot
ett regelrätt grafiskt gränssnitt senare. Detta är utanför denna labbseriens
omfång, men är möjligen något jag gör själv efteråt, av eget intresse.

Ett val jag har gjort i strukturen av programmet är att använda moduler för vissa
delar. Detta är för att det inte ska gå att skapa fler än en instans av t.ex.
kösystemet och databehållarna, som bara skulle röra till det. GUI:t är också 
moduler, men skulle enkelt kunna göras om till klasser om man vill göra ett 
distribuerat program, t.ex. där flera hyrterminaler är kopplade till en huvuddator.
Då kan programmets backend ligga där, men en instans av GUI:t finnas för varje
fysisk terminal.

KLASSER:
Denna rubrik beskriver klasser som har tillkommit eller förändrats. För mer information,
se README för laboration 3 samt kommentarer i programfilerna.

  /data/:
    - database_handler.rb: (NY) modul som hanterar all kommunikation med databasen.
      Blir därmed ett gränssnitt mellan de två olika. Används när programmet startar
      för att läsa in databasen, samt när någon data förändras och behöver skrivas
      till databasen.
    - /products/article.rb: utökat med id-nummer för varor, så att referenser till en
      specifik vara kan sparas i databasen på ett smidigt sätt.
    - customer.rb: lagt till id-nummer för kund, så att referenser till en specifik
      kund kan sparas i databasen på ett smidigt sätt.
    - order.rb: buggfix, räknar nu ut uthyrningstiden på rätt sätt.
    - order_handler.rb: säger till DatabaseHandler att lägga till information i
      databasen så fort något förändras (t.ex. beställningar skapas eller lämnas
      tillbaka). Metoder för att skapa saker med information från databasen lades
      också till. Kund-relaterade metoder fungerar med kund-id.
    - product_handler.rb: kan nu hantera id-nummer för produkter.

  /views/:
    - save_menu.db: (NY) modul som hanterar den nya funktionen att spara ner
      information från databasen till fil. Tillåter två alternativ: spara kundregister,
      och spara ekonomisk information.

FELHANTERING:
Felaktig indata från användaren hanteras så fort som möjligt genom if-satser, och
användaren meddelas. Genom if-satserna kan jag välja att endast utföra en uppgift
ifall indatan är korrekt, istället för att göra det ändå och stöta på problem senare.
Detta, menar jag, är att att föredra över rescue-satser. Rescue-satser används dock
vid ett ställe: när man ändrar priser. Detta eftersom jag använder Integer-klassen
för att få en indata till ett nummer, eftersom jag vill försäkra mig om att användaren
endast skriver in siffror. Indatan "10k" ska nämligen inte bli 10, utan ge felmeddelande
istället.

Vad som görs när ett fel uppstår hanterar jag på två olika sätt, beroende på läga:
meddelar användaren, eller gör ingenting. I icke-kritiska ögonblick så väljer jag att
göra ingenting (som när man t.ex. skriver in ett felaktigt menyval i huvudmenyn).
Vid känsliga delar i programmet, så som vid hyrtillfället så meddelar jag användaren
att indatan var felaktig. På så sätt behöver jag inte ge användaren överflödig information
även när denne inte önskar det.

Jag låter programmet skapa databasen om den inte kan hittas. På så sätt kan jag minimera
fel som beror på databasen. Utöver detta skulle man även kunna undersöka så att databasen
har rätt format (d.v.s. inte har felaktiga tabeller i sig), för att gardera sig ytterligare
mot sådana fel. Detta har jag valt att inte göra, eftersom jag anser att SQL ligger lite
utanför denna kursens område.

UML:
För UML över utvalda klasser, se filen "uml.png"

CHANGES:
- Produkter & kunder har nu id-nummer
- Databas som sparar data mellan körningar
- Möjlighet att spara till fil:
    - kundregister
    - ekonomisk information (prislista, utbud, beställningar, inkomst)
- Uthyrningstid (och därmed pris) räknas nu ut på rätt sätt