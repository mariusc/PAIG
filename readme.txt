Constantinescu Marius
341 C1
Tema 1

Am folosit un backtracking, asemanator celui din laboratorul 2.
Codificarea unei stari: stare(X,Y,Harta,Obiect); Obiect = 0 daca nu am obiect, 1 altfel.

Gasirea solutiilor se face in felul urmator:
 Se cer N obiecte. Pentru fiecare obiect, fac o cautare. 
 Mai intai, vreau sa fac un drum din pozitia initiala la un obiect. 
 Plec din starea initiala, imi setez ca stare finala stare(_,_,_,1). 
 Ma plimb prin harta cu bkt pana gasesc un obiect. 
 In acel moment, tin minte drumul in Solutie.
 Drumul inapoi mi-l calculez, pentru ca nu e neaparat acelasi cu drumul dus.
 Pentru calculul drumului catre starea initiala: 
   imi creez o noua harta, in care pun 0 in locul tuturor celorlalte obiecte
   imi pun 1 pe (fosta) stare initiala, cea din care pleaca agentul la inceput si in care trebuie sa duca obiectele, devenind astfel stare finala
   fac o noua cautare la fel ca prima, avand ca stare initiala starea curenta (ultima stare din Solutie)
   ajung cu obiectul la locul dorit (starea initiala)
   salvez drumul in Solutie (append)
   modific harta cum era initial
   sterg din harta obiectul proaspat mutat
Reiau procesul pana gasesc toate obiectele cerute.

Daca mi se cer mai multe obiecte decat am pe harta, intorc false.

Pentru implementarea miscarilor pe gheata, imi tin minte directia din care vin (o dau ca parametrii la "misca").
Pentru a evita cazul in care ma plimb intre 2 gauri de vierme inainte si inapoi, am un parametru care este 1 daca pot intra prin gaura (nu am venit din una din starea anterioara), 0 altfel.
Pentru a cauta perechea unei gauri de vierme folosesc predicatul google. (:D)


::Predicate::
onBoard(X,Y,Harta,Tip): 
	verifica daca X si Y sunt pe harta si intoarce in Tip valoarea din harta de la acea pozitie
found(X,Y,Harta,Obiect):
	intoarce in Obiect 1 daca in pozitia (X,Y) am un obiect, 0 altfel
iaHarta(stare, stareCuHartaNoua,Harta):
	incarca in a doua stare harta data ca parametru
ilegala(stare(X,Y,Harta,Obiect):
	intoarce starile ilegale
misca(stare1, stare2):
	seteaza regulile pentru miscari intre stari (pe harta)
google(X1,Y1,X2,Y2,Harta,Val):
	intoarce in X2,Y2 capatul tunelului care incepe la X1,Y1 pe Harta si are numarul Val
golesteHarta(Harta1,Harta2):
	pune 0 pe harta in toate celulele in care era 1; //e folosita pentru intoarcere
pune1(X,Y,Harta,HartaNoua):
	intoarce in HartaNoua Harta cu valoarea 1 in (X,Y)
lcv(Stare, Solutie, Vizitate, DirX, DirY, Gaurica):
	aici e practic mecanismul de bkt: face miscarea daca nu e ilegala si nu am mai fost in acea stare. primeste starea, intoarce solutia. mai primeste lista de vizitate, directiile pe X si Y si daca am fost sau nu printr-o gaura de vierme
rezolva(X,Y,Harta,Harta2,Solutie,Solutie2):
	apeleaza lcv pentru a gasi obiectul, goleste harta, pune 1 in starea initiala si face din nou lcv pentru a se intoarce
modificaHarta(Harta1,Stare,Harta2):
	intoarce in Harta2 Harta 1 cu obiectul proaspat gasit sters
construiesteRez:
	imi transforma lista de stari in formatul cerut la iesire
aranjeaza:
	imi sterge 1 de pe pozitia initiala dupa ce m-am intors cu un obiect
go:
	apeleaza rezolva si intoarce in Rezultat lista de miscari
tema12:
	apeleaza go de cate ori e necesar (cate obiecte se cer)
tema1: 
	apeleaza tema12 si afiseaza rezultatul
	
am mai folosit 
prim(A,B)- intoarce in B primul element din A 
rest(A,B)- intoarce in B lista A fara primul element
reverse(A,[],B)- intoarce in B inversul lui A

In arhiva mai exista un fisier cu exemple de apeluri si rezultate.
   
