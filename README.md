Rozvrh – iOS aplikace pro přístup k rozvrhu ČZU

Tato aplikace umožňuje studentům České zemědělské univerzity v Praze se přihlásit pomocí svého UIS účtu a zobrazit svůj rozvrh.

Funkce

- Přihlášení pomocí UIS (https://is.czu.cz)
- Načtení HTML rozvrhu přes URLSession
- Extrakce předmětů z HTML
- Zobrazení předmětů ve formě seskupeného seznamu
- Aplikace je ve vývoji – aktuálně umožňuje pouze přihlášení a zobrazení předmětů (názvy, kódy a jména vyučujících). Další funkce budou postupně přibývat.**


Použité technologie

- SwiftUI
- URLSession
- NSRegularExpression pro parsování HTML
- MVVM princip (LoginViewModel)

Náhled obrazovek

<img width="362" alt="image" src="https://github.com/user-attachments/assets/6e7df616-91d8-4e9c-962f-599e27f81da3" />
<img width="362" alt="image" src="https://github.com/user-attachments/assets/43302255-d479-4341-9e75-10e94e44bdc9" />
<img width="362" alt="image" src="https://github.com/user-attachments/assets/15552f22-76f7-4d9d-9eae-27a552d00ad4" />
