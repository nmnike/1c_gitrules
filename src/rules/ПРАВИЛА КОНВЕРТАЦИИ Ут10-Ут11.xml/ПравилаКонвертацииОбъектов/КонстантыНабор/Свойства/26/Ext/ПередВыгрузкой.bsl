Запрос = Новый Запрос("
|ВЫБРАТЬ ПЕРВЫЕ 1
|	1
|ИЗ
|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
|ГДЕ
|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомитентом)
|");

Значение = Не Запрос.Выполнить().Пустой();
