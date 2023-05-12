# Tema 3 PCLP2 (IOCLA) - Poli Cat Invasion

# Task 1
Stiind ca nodurile sunt numere intregi de la 1 la n, pentru a rezolva primul
task, am iterat de la n la 1, iar pentru fiecare iteratie, am cautat nodul
cu numarul iteratorului si l-am pus pe stiva. Cand au fost parcruse toate
valorile de la n la 1, pe stiva vom avea nodurile ordonate crescator, exact
ce ne trebuie. Mai trebuie doar sa facem legaturile dintre noduri din campurile
next. Pentru asta, dam pop de pe stiva primului nod in eax. Parcurgem nodurile
ramase si actualizam legaturile dintre noduri.

# Task 2
Pentru a calcula CMMMC-ul dintre a si b am calculat mai intai CMMDC-ul lui a si b,
folosind metoda cu scaderi (Euclid), apoi am aflat CMMMC prin formula a*b / CMMDC.

La a doua cerinta, am iterat peste toate caracterele sirului, comparand fiecare 
caracter (byte) cu '('. In functie de ce tip de paranteza se gaseste in sir, edx este
incrementat sau decrementat. Daca se gaseste '(' atunci edx se incrementeaza, in caz
contrar se decrementeaza. La sfarsitul oricarei operatii dintre cele doua, se compara
valoarea din edx cu 0. Daca mai sunt caractere de evaluat, iar valoarea din edx este 0, 
inseamna ca nu sunt echilibrate parantezele. Daca se ajunge la finalul algoritmului si valoarea din edx este 0, s-au facut la fel de multe 
incrementari si decrementari, ceea ce inseamna ca parantezele sunt 
echilibrate. In functie de valoarea din edx, se pune 0 sau 1 in eax cu stiva.

# Task 3
Pentru get_words, am apelat corespunzator strtok mai intai pentru a gasit
primul cuvant , punandu-l in words, apoi am folosit acelasi principiu si
pentru restul cuvintelor. In functia comparator, apelam strlen pentru
ambele cuvinte, scadem cele doua valori, iar daca rezultatul nu este 0,
returnam diferenta de caractere dintre cele doua. Insa daca scaderea are ca
rezultat 0, apelam functia strcmp. In final, sort doar pune pe stiva 
parametrii necesari pentru a apela quicksort si intoarce matricea words
sortata.

# Bonus x64
In primul rand, am calculat dimensiunea lui v, adunand lungimile lui v1 si
v2. Apoi in bucla etichetei start, se adauga pentru fiecare ciclu, un
element din v1 si un element din v2, pana cand nu mai sunt in v1 sau v2
elemente de pus in v. Implementarea este foarte simpla si functioneaza
indiferent de ordinea in care sunt pasati vectorii sau lungimile lor.

# Bonus CPUID
Pentru a gasi CPU manufacturer, apelam CPUID cu valoarea 0 in eax si ne
este returnat numele producatorului impartit pe 4 bytes in ebx, ecx si edx.

In features, apelam CPUID cu valoarea 0 in eax, pentru a determina daca
masina suporta VMX, facem and logic pe al 5-lea cel mai nesemnificativ bit
folosind un bitmask. La fel se procedeaza si pentru RDRAND si AVX, insa
verificam al 30-lea si respectiv al 28-lea cel mai nesemnificativ bit.

Pentru line size, apelam CPUID cu valorile 4 in eax si 2 in ecx, si 
extragem ultimii 12 biti. Pentru a calculat L2 cache size, ne trebuie 
valorile Ways, Partitions, Line_size si sets. Avem deja in eax valoarea
line_size + 1, iar in ecx sets+1. Pentru partitions, extragem bitii dintre
12 si 21 iar pentru Ways bitii dintre 22 si 31. Dimensiunea se cere in
bytes, asa ca impartim la 8 rezultatul inmultirilor.
