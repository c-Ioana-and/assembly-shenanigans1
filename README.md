# x86 ASM - exercitii

TODO: find the task descriptions...

## Implementare

### TASK 1:

In fisierul "simple.asm" am folosit registrul eax (mai precis,
subregistrul al) pentru a retine litera din string-ul plain care trebuie
sa fie shiftata. Dupa adaugarea step-ului (retinut in registrul dl), verific
daca litera curenta mai este litera mare sau nu. Daca da, inserez la adresa
edi + ebx litera si trec la urmatorul caracter din plain, incrementand valoarea
din registrul ebx (ebx retine pozitia curenta in plain si enc_string).
Atlfel, sar la eticheta "modify" care mai intai scade valoarea 26 din
registrul al (nu se fac shiftari cu valori mai mari decat 26, deci se poate
scade 26 pentru a retine o litera mare in registru).


### TASK 2:

1. Pentru acest task am folosit 2 registre: ecx (cl si ch) pentru a
retine abcisele si ordonatele celor doua puncte de la adresele ebx + 0 si 
ebx + 4. Daca cele doua puncte au abcise egale, inseamna ca distanta dintre
cele doua puncte este data de diferenta dintre ordonatele lor, si trebuie
sa le retin in cl si ch pentru a putea efectua diferenta dintre cele doua,
avand grija ca aceasta diferenta sa fie pozitiva (daca nu e pozitiva,
interschimb  valorile folosind jump-ul la eticheta switch). Analog pentru
cazul in care cele doua puncte se afla pe aceeasi axa orizontala.
2. Am preluat implementarea de la 2.1 si am modificat-o pentru a
calcula distantele pentru fiecare pereche de puncte consecutive, incrementand
adresa lui eax cu 4 pentru a ajunge la urmatorul punct. Pentru a retine
fiecare distanta am folosit o variabila globala (distance), luand valoarea
din acesta si inserand-o la adresa lui ebx + 4k, unde k este pozitia in care
introduc distanta in vector.
3. Pentru a determina daca o distanta este patrat perfect, am luat un
i (implementat ca fiind in registrul esi) si i-am calculat patratul (continut
in variabila sum) in eticheta "square". Daca i^2 este mai mic decat distanta,
incrementez valoarea din registrul esi si recalculez patratul sau (recalculate). Daca (valoarea din esi)^2 este egala cu distanta, este patrat perfect (eticheta good). Altfel, distanta data nu este patrat perfect (eticheta bad). La eticheta next incrementez adresele lui ebx si ecx pentru a trece la
urmatoarea distanta.

### TASK 3:

Am ales sa nu folosesc matricea tabula_recta, asa ca am folosit
registrul edi pentru a putea cripta testul din string-ul plain. M-am folosit
de trei variable globale:
- in sum voi retine rezultatul operatiei (litera de la adresa din registrul ebx
 - litera de la adresa din ecx)
- index - va retine pozitia curenta din string-ul de encryptat
- indexkey - va retine pozitia curenta din cheie, ea va deveni zero atunci cand
ajung la finalul cheii
Daca diferenta dintre cele doua litere este pozitiva, litera noua va re-
zulta din calculul: "Z" - diferenta (sum) - 1. Altfel, litera noua este rezul-
tatul calculului "A" - diferenta. Indiferent de semnul acestei diferente,
rezultatul va fi retinut in registrul edi si va fi introdus la adresa din esi 
(la eticheta encrypted).
Lungimile celor doua string-uri au fost retinute folosind stiva, avand
grija sa descresc lungimea string-ului de criptat si sa cresc lungimea cheii
pana cand ajung la finalul acesteia, moment in care lungimea trebuie sa devina 0
pentru a putea repeta cheia de-al lungul string-ului plain.

### TASK 4:
	
In implementarea acestui task am considerat matricea un vector de N * N
elemente. Inainte de a parcurge matricea, calculez in cate "patrate" se va impar-
ti matricea (prin patrat ma refer la un contur al matricei, <link>). Practic
vor fi N/2 patrate (sau (int)N/2 + 1 pentru N impar), N fiind numarul de linii
si coloane ale matricei.
Odata ce am calculat numarul de patrate, trebuie sa calculez pentru
fiecare patrat (sau contur de patrat mai bine spus) de unde incepe in vector
prima linie, ultima coloana, ultima linie si prima coloana, precum si numarul
necesar de pozitii pentru a putea sari de la o linie sau coloana la alta. Dupa
aceea, iau si parcurg prima linie (loop1), ultima coloana (loop2), ultima linie
(loop3) si prima coloana (loop4) a conturului de patrat, iau valorile din matrice
la care adaug litera corespunzatoare de la adresa din registrul ebx, unde se afla
textul de criptat, si inserez rezultatul la adresa din registrul edx.
Am folosit urmatoarele variabile globale:
- lc - retine acel numar de pozitii pentru trecerea de la o linie/coloana la
alta
- newlc - numarul de pozitii care trebuiesc sarite va scadea pentru fiecare
contur de patrat
- max - va retine numarul de elemente care va tb afisat pe fiecare linie/coloana
- divided - retine numarul de patrate
- poz - variabila care va creste pana la divided
	
