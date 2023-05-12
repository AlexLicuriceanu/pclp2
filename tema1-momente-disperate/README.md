# Tema 1 PCLP2 (IOCLA) - Momente Disperate.

> **Note**
> Testele 2 si 9 trec local, dar nu si pe vmchecker.

```
TEST test1........................................... PASSED
TEST test2........................................... FAILED
TEST test3........................................... PASSED
TEST test4........................................... PASSED
TEST test5........................................... PASSED
TEST test6........................................... PASSED
TEST test7........................................... PASSED
TEST test8........................................... PASSED
TEST test9........................................... FAILED
Test memory.......................................... FAILED
```

# MAIN
Cat timp comanda primita nu este exit, vom citi linii de la stdin si se apeleaza functia parseInput(), care imparte parametrii comenzii dupa spatii si ii returneaza prin intermediul vectorului tokens[], iar apoi se intra pe if-uri, unde se compara tokens[0], comanda primita de la tastatura cu comenzile posibile. Daca primeste comanda insert, se aloca memorie pentru doua noi obiecte, newHead si newStruct si se initializaeaza variabila data_size, care stocheaza numarul de byti pe care il are instructiunea, in functie de cele 3 tipuri de bancnote. Se aloca memorie pentru auxArr, in care vom copia bytii din tokens[] ai primul nume, ai sumelor si ai celui de-al doilea nume, in ordinea aceasta. Variabila pos functioneaza ca un offset, si arata spre inceputul zonei unde se va copia fiecare parametru, si este incrementata de fiecare data cand se foloseste memcpy(). In final, se initializaeaza campurile type, len, header si data din newStruct si newHead si se apeleaza functia add_last.

# ADD_LAST
Functia add_last verifica mai intai daca lungimea vectorului arr este 0, caz in care i se aloca lui arr atatia bytes cat are nevoie structura care trebuie adaugata, se copiaza memoria din data->data in arr si se incrementeaza lungimea lui arr cu lungimea structurii, aflata in campul data->header->len. In cazul in care lungimea nu este 0, se apeleaza functia realloc(), marind zona de memoria a lui arr cu data->header->len bytes, exact cat este nevoie pentru noile data, care se copiaza la adresa lui arr + lungimea veche si se incrementeaza variabile len, care salveaza lungimea lui arr in bytes. Dupa inchiderea apelului lui add_last(), in main se elibereaza memoria folosita de newStruct, newHead si auxArr, deoarece nu mai este nevoie de aceste, datele fiind salvate deja in arr.

# ADD_AT
Pentru add_at(), partea din main() este aproape identica, doar ca se verifica corectitudinea indexului la care se doreste inserarea. Daca indexul este mai mare sau egal cu 0 si mai mic decat numarul de structuri salvate in arr, se apeleaza add_at(), dar daca indexul depaseste numarul de structuri salvate sau arr este gol (len == 0), se apeleaza functia add_last(). In apelul lui add_at(), realocam zona de memoria a lui arr cu data->header->len + len bytes si folosim un pointer startPtr care initial arata spre inceputul zonei de memorie a lui arr, iar folosind un counter, am calculat offsetul la care trebuie sa inseram structura. Variabila offset este incrementata la fiecare ciclare a while-ului cu valoare lungimii fiecarei structuri  in bytes si la final va salva de la cat bytes trebuie inserata structura de la inceputul zonei lui arr. Variabila nrBytesMove retine numarul de bytes care trebuie mutati la dreapta cu data->header->len bytes si este calculata scazand din lungimea totala a lui arr offsetul calculat mai devreme. Folosind memmove(), mutam memoria de la startPtr cu data->header->len bytes la dreapta, iar astfel avem exact spatiul necesar pentru a copia noua structura. La adresa gasita de startPtr, se copiaza data->data, de lungime data->header->len bytes si se actualizeaza lungimea lui arr cu lungimea noua.

# PRINT
In functia print, variabila i este un offset fata de inceputul pointerului catre zona de memorie ocupata de arr, iar la fiecare ciclare este incrementat cu lungimea structurii care tocmai a fost afisata, pana cand se depaseste lungimea lui arr. arr[i] si arr[i+1] contin tipul respectiv lungimea structurii. De la arr[2*sizeof(uint8_t) + i] va incepe sirul de caractere ce reprezinta primul nume din fiecare structura, iar in functie de tipul structurii dat de arr[i] adaugam sizeof(uint8_t), sizeof(uint16_t) si sizeof(uint32_t) pentru a gasi inceputul celui de-al doilea nume. Cele doua numere se gasesc la arr[2*sizeof(uint8_t) + strlen(name1) + 1 + i] si arr[2*sizeof(uint8_t) + strlen(name1) + 1 + sizeof(uint8_t sau uint16_t sau uint32_t) + i]. Cu ce sizeof() se aduna pentru a afisa cel de-al doilea numar depinde de tipul structurii. Pentru tipurile 2 si 3 am scris doua functii bytes_to_int16() si bytes_to_int32() care primesc un vector de bytes ca parametrii si returneaza fie uint16_t sau uint32_t corespunzator byte-ilor. Toate ascestea sunt afisate la ecran si variabile i este incrementata cu lungimea structurii careia i s-a facut afisarea.

# FIND
In main, variabila index salveaza indicele ca int, folosind functia strtol() si se apeleaza find(). In functia find() se verifica sa fie indicele valid, si folosind din nou un counter si un offset, pointerul startPtr va arata catre inceputul zonei de memorie a structurii de la indicele dorit. Afisarea se face intr-un mod similar cu ce de la functia print().

# DELETE_AT
In main(), indexul este facut in int cu functia strtol() si in cazul in care indexul depaseste numarul de structuri, delete_at() va elimina ultima structura din arr, altfel delete_at() se apeleaza normal cu index. In delete_at() folosim startPtr din nou pentru a gasi zona de memoria de unde incepe structura care trebuie eliminata, iar variabila nrBytesRemove salveaza numarul de bytes care trebuie eliminati de pe pozitia startPtr. Daca indexul nu este al ultimei structuri, mutam memoria de pe startPtr + nrBytesRemove la stanga cu nrBytesRemove bytes, astfel suprascriem structura care trebuia sa fie eliminata. Ulterior zona de memoria a lui arr este realocata cu len - nrBytesRemove bytes si lungimea lui arr este decrementata cu cati bytes am eliminat. In cazul in care indexul este a ultimei structuri, nu se mai intra in if, ci doar se truncheaza zona de memoria a lui arr cu nrBytesRemove bytes.

Cand este intalnita comanda exit, se elibereaza memoria pentru arr si pentru commandLine si se inchide programul.
