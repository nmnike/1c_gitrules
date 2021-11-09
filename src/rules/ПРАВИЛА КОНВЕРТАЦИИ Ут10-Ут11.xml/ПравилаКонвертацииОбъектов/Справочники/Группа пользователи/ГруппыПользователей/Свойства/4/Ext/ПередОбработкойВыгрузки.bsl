﻿Запрос = Новый Запрос;
Запрос.Текст = 
"ВЫБРАТЬ
|	Пользователи.Ссылка КАК Пользователь
|ИЗ
|	Справочник.Пользователи КАК Пользователи
|ГДЕ 
|	Пользователи.Родитель В ИЕРАРХИИ(&Группа)
|	И Не Пользователи.ЭтоГруппа
|";
Запрос.УстановитьПараметр("Группа", Источник.Ссылка);

КоллекцияОбъектов = Запрос.Выполнить().Выгрузить();

Запрос = Новый Запрос;
Запрос.Текст = 
"ВЫБРАТЬ
|	&Группа КАК ГруппаПользователей,
|	Пользователи.Ссылка КАК Пользователь
|ИЗ
|	Справочник.Пользователи КАК Пользователи
|ГДЕ 
|	Пользователи.Родитель В ИЕРАРХИИ(&Группа)
|	И Не Пользователи.ЭтоГруппа
|";
Запрос.УстановитьПараметр("Группа", Источник.Ссылка);

КоллекцияОбъектов = Запрос.Выполнить().Выгрузить();

Для Каждого ОбъектВыгрузки ИЗ КоллекцияОбъектов Цикл
	ВыгрузитьПоПравилу(ОбъектВыгрузки,,,,"СоставГруппПользователей");	
КонецЦикла;
