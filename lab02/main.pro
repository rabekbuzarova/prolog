% Copyright
/*
Какие предметы входят в блюдо
В каких блюдах используется данный предмет
Калорийность каждого предмета в блюде
Общая калорийность блюда
*/

implement main
	open core, file, stdio

domains
	predmet = физика;химия;математика;история;русский.

class facts - stud_baza
	студент:(integer НомерСтуд, string ФИО,integer Телефон).
	группа:(integer ID,string Направление,integer Курс,string Название).
	учится_в:(integer ID,integer НомерСтуд).
	староста:(integer ID,integer НомерСтуд).
	предмет:(integer ID_P, predmet Название,string Направление,integer Курс).
	оценка:(integer ID_P,integer НомерСтуд,integer Оценка).

class facts
	s : (real Sum) single.

clauses
	s(0).

class predicates
	состав_группы: (string Название) nondeterm.
	список_студентов_старосты : (integer НомерСтуд) nondeterm.
	список_предметовв_студента_курс : (string ФИО, integer Курс) nondeterm.
	кол_четверок_предмета_студента : (string ФИО, predmet Название) nondeterm.

clauses
	состав_группы(X) :-
		группа(N,_,_,X),
		write("Состав группы ", X, ":\n"),
		учится_в(N,W),
		студент(W, NamePr, _),
		write(" ", NamePr),
		nl,
		fail.
	состав_группы(X) :-
		группа(_,_,_,X),
		write("Конец списка"),
		nl,nl.

	список_студентов_старосты(X) :-
		староста(N,X),
		студент(X, NamePr, _),
		write("Список студентов где староста ", NamePr, ":\n"),
		учится_в(N,W),
		студент(W, Z, _),
		write(" ", Z),
		nl,
		fail.
	список_студентов_старосты(X) :-
		староста(_,X),
		write("Конец списка"),
		nl,nl.


	список_предметовв_студента_курс(X,Y) :-
		write("Список предметов студента", X, " на " ,Y ," курсе:\n"),
		студент(X1, X, _),
		оценка(ID_P, X1,_),
		предмет(ID_P,Z,_,_),
		write(" ", Z),
		nl,
		fail.
	список_предметовв_студента_курс(X,_) :-
		студент(_, X, _),
		write("Конец списка"),
		nl,nl.

	кол_четверок_предмета_студента(X,Y) :-
		студент(X1, X, _),
		assert(s(0)),
		оценка(ID_P,X1,4),
		предмет(ID_P,Y,_,_),
		s(Sum),
		asserta(s(Sum + 1)),
		fail.
	кол_четверок_предмета_студента(X,Y) :-
		студент(_, X, _),
		s(Sum),
		write("Колличество 4 по предмету ", Y),
		write(" у ", X, " = " ,Sum),
		nl.


	run() :-
        console::init(),
        reconsult("stud.txt", stud_baza),
        состав_группы("НФИбд-01_21"),
        fail.
	run() :-
		список_студентов_старосты(1032216436),
		fail.
	run() :-
		список_предметовв_студента_курс("Васильев Сергей Иванович",1),
		fail.
	run() :-
		кол_четверок_предмета_студента("Иванов Иван Иванович",химия),
		fail.
	run() :-
		succeed.

end implement main

goal
	console::run(main::run).
