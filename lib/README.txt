README - Ruby Beach Water Sports (Lab 3)
Version 3 (2011-07-19)
Skribent: Johannes Keinestam

UPPDATERADE RUBRIKER: CHANGES, KLASSER, FELHANTERING, UML.

INSTRUKTIONER:
I Windows-miljö kan programmet köras genom att dubbelklicka på filen main.rb.
Under *nix-miljöer så startas det via terminalen genom kommandot "ruby main.rb".

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
se README för laboration 2 samt kommentarer i programfilerna.

  /data/:
    - order_handler.rb: (NY) modul som hanterar beställningar och kunder, såsom
      metoder för uthyrning och återlämning. Refaktorerad från data_container.rb.
    - product_handler.rb: (NY) modul som hanterar sortimentet. Refaktorerad från
      data_container.rb.
    - customer.rb: instansvariabler synliga så att mer information kan skrivas ut
      i kundregistret och för återkommande kunder under uthyrningen. Kreditkort
      och adress tillagt.
    - order.rb: instansvariabler synliga så att de kan användas i den ekonomiska
      statistiken.

    Produktklasser flyttade till undermapp /products.
    - article.rb: instansvariablar på klassnivå för priser. Dessa är synliga genom
      ett knep som lägger till en attribute accessor på klassnivå (se kod).

  /views/:
    - financial_menu.rb: (NY) modul som hanterar ekonomimenyn. Har undermenyer för att
      presentera intäkter samt priser. Tillåter redigering av priser. Presenteras
      i tabeller.
    - listings_menu.rb: (NY) modul som har hand om de tidigare menyerna Customer registry
      och Selection.
    - rent_menu.rb: hämtar nu data från kundregistret ifall man hyrt förut, så att man
      slipper skriva in sina uppgifter igen. Frågar nu efter adress och kreditkort
      (den sistnämnda måste vara rätt format, 4x4 siffror separerade med bindesträck).
    - return_menu.rb: visar mer information om beställningen vid återlämning: pris och
      datum.

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

UML:
För UML över utvalda klasser, se filen "uml.png"

CHANGES:
- Undermenyer
- Felhantering
- Prissystem tillagt (bas- samt tim- och dagspriser)
- Ekonomisk statistik
- Prislista (redigerbar)
- Omstruktureringar
- Automatisk ifyllnad av kundinformation
- Nytt UML