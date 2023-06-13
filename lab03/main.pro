implement main
	open core, file, stdio

domains
	predmet = физика;химия;математика;история;русский.
	студенты = студенты(string ФИО,integer Телефон).


class facts - stud_baza
	студент:(integer НомерСтуд, string ФИО,integer Телефон).
	группа:(integer ID,string Направление,integer Курс,string Название).
	учится_в:(integer ID,integer НомерСтуд).
	староста:(integer ID,integer НомерСтуд).
	предмет:(integer ID_P, predmet Название,string Направление,integer Курс).
	оценка:(integer ID_P,integer НомерСтуд,integer Оценка).

class predicates %Вспомогательные предикаты
	длина : (A*) -> integer N.
	сумма_элем : (real* List) -> real Sum.
	среднее_списка : (real* List) -> real Average determ.
clauses
	длина([]) = 0.
	длина([_ | T]) = длина(T) + 1.

	сумма_элем([]) = 0.
	сумма_элем([H | T]) = сумма_элем(T) + H.

	среднее_списка(L) = сумма_элем(L) / длина(L) :-
		длина(L) > 0.

class predicates
	состав_группы: (string Название) -> string* Список_Студ determ.
	состав_группы_расш : (string Название) -> студенты* determ.
	кол_студ : (string Название) -> integer N determ.
	список_предметов_студента_курс : (string ФИО, integer Курс) -> predmet* Предметы determ.
	средняя_оценка_предмета_студента : (string ФИО, predmet Название) -> real Кол determ.

clauses
	состав_группы(X) = Nprs :-
		группа(N,_,_,X),
		!,
		Nprs =
		[ NamePr ||
			учится_в(N,W),
			студент(W, NamePr, _)
		].
	кол_студ(X) = длина(состав_группы(X)).

	состав_группы_расш(X) =
		[ студенты(NamePr, Tel) ||
			учится_в(N,W),
			студент(W, NamePr, Tel)
		] :-
		группа(N,_,_,X),
		!.

	 список_предметов_студента_курс(X,Y) = List :-
		!,
		List =
		[ NameBl ||
			студент(X1, X, _),
			оценка(ID_P, X1,_),
			предмет(ID_P,NameBl,_,Y)
		].


	средняя_оценка_предмета_студента(X,Y) =
		среднее_списка(
		[ Z ||
			предмет(ID_P,Y,_,_),
			оценка(ID_P,X1,Z)
		]) :-
		студент(X1, X, _),
		!.



class predicates %Вывод на экран предметов студента и номера телефона
	write_stud : (студенты* Студенты_И_Телефон).

clauses
	write_stud(L) :-
	foreach студенты(NamePr,  Unit) = list::getMember_nd(L) do
		writef("ФИО: %s. Телефон:%s\n", NamePr, toString(Unit))
	end foreach.

	run() :-
        console::init(),
        reconsult("stud.txt", stud_baza),
		fail.


	run() :-
		X = "НФИбд-01_21",
		L = состав_группы(X),
		write("Состав группы(списком) ", X, ":\n"),
		write(L),
		nl,
		write("Количество человек в группе = "),
		write(кол_студ(X)),
		nl,nl,
		fail.

	run() :-
		X = "НФИбд-01_21",
		write("Состав группы(поэлементно) ", X, ":\n"),
		write_stud(состав_группы_расш(X)),
		nl,
		fail.
	run() :-
		write("Список предметов студента Васильев Сергей Иванович на 1 курсе:\n"),
		L = список_предметов_студента_курс("Васильев Сергей Иванович",1),
        write(L,"\n"),
        nl,
		fail.

	run() :-
        write("Какую среднюю оценку имеет Иванов Иван Иванович по химии:\n"),
		L=средняя_оценка_предмета_студента("Иванов Иван Иванович",химия),
        write(L,"\n"),
        nl,
		fail.
	run() :-
		succeed.

end implement main

goal
	console::run(main::run).
