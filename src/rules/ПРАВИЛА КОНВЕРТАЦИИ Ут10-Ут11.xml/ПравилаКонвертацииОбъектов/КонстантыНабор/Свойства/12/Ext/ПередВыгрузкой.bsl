Запрос = Новый Запрос("
|ВЫБРАТЬ ПЕРВЫЕ 1
|	1
|ИЗ
|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
|ГДЕ
|	РеализацияТоваровУслуг.ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером)
|");

Значение = Не Запрос.Выполнить().Пустой();
