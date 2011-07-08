README - Ruby Beach Water Sports (Lab 2)
Version 2 (2011-06-30)
Skribent: Johannes Keinestam

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
I mappen "views" kan de delar i programmet som har med visuell representation
hittas. Alla dessa delar är moduler, eftersom det inte är av intresse att skapa
fler än en instans av dem. Nedan följer korta beskrivningar om varje fil/modul.

	- customer_list_menu.rb: modul för att visa menyn som visar alla kunder som
	  någon gång har lånat en vara i systemet. Visar nya kunder som står i kö.
	- messenger.rb: modul för att visa ett meddelande i terminalen för användaren.
	  Kan också visa error-meddelanden. 
	- rent_menu.rb: modul som sköter hantering av menyn där användaren välja vilken
	  vara denne vill hyra. Visar alla varukategorier som finns i programmet.
	- return_menu.rb: modul som hanterar menyn där användaren får välja vilken vara
	  de vill lämna tillbaka. Visar en lista över alla uthyrda varor.
	- selection_menu.rb: modul för den meny som i labbanvisningarna kallades "Lista 
	  kunder". Eftersom denna skulle markera vilka varor som var lediga/upptagna 
	  genom detta, tyckte jag detta namnet passade bättre. Visar lista över alla varor,
	  och därefter om den är ledig eller upptagen (och då av vem).
	- welcome_menu.rb: modul för den meny som visas när användaren startar programmet.
	  Låter denne att välja en submeny, eller avsluta programmet.

Mappen "data" innehåller de delar som har med själva funktionaliten att göra.
De delar som det bara ska finnas en upplaga av (kösystemet, databehållaren) är
moduler, resten är klasser som blir objekt under körningen.

	- article.rb: klass som beskriver en generisk produkt i programmet. Denna 
	  byggs ut genom arv när de egentliga produkterna skapas.
	- Varorna, klasser: boat.rb, diving_gear.rb, jet_ski.rb, surfboard.rb.
	- customer.rb: klass för en kund i systemet. Denna kund har änsålänge
	  bara ett namn, men kan enkelt utökas med t.ex. kreditkortsnummer, adress osv.
	- data_container.rb: modul som håller koll på sortimentet. Sköter logiken om
	  utlåning och återlämning.
	- queue_system.rb: modul för kösystemet, som används när en kund vill hyra en
	  viss vara, men alla dessa varor är redan utlånade. Rätt logiktung.

I rotmappen ligger en ynka Ruby-fil, samt lite dokumentation (inkl. denna).

	- main.rb: startar programmet, genom att skapa sortimentet och hyra ut tre
	  slumpade varor. När den är klar med det visas huvudmenyn.

Programmet är i övrigt utförligt dokumenterat, så för ytterligare information
rekommenderar jag att ta en titt på kommentarerna i .rb-filerna.

UML:
För UML över utvalda klasser, se filen "uml.png"

CHANGES:
- Kösystem tillagt, för när alla önskade varor är upptagna.
- Nya menyer: selection, customer registry.
- Fler produkter (tre lånas ut automatiskt vid start).
- Meddelandeutskrifter till användare.
- Kraftiga omstruktureringar i kod.
- Readme uppdaterad: Programdesign, Klasser, UML.