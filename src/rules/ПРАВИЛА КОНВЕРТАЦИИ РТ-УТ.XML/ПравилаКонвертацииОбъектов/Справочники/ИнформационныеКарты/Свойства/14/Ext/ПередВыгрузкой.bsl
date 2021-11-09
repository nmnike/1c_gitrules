﻿Если Источник.ВидКарты = Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
	
	СтрокаШтрихкода = РаботаСТорговымОборудованием.ПолучитьШтрихКод(Источник.Ссылка);
	Если СтрокаШтрихкода <> Неопределено Тогда
		Значение = СтрокаШтрихкода.ТипШтрихкода;
	КонецЕсли;
	
ИначеЕсли Источник.ВидКарты = Перечисления.ВидыИнформационныхКарт.Смешанная Тогда
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Узел.ВидИнформационнойКартыСмешаннаяВУТ
	|ИЗ
	|	ПланОбмена.ОбменУправлениеТорговлейРозничнаяТорговля КАК Узел
	|ГДЕ
	|	Узел.Ссылка = &УзелПланаОбмена";
	Запрос.УстановитьПараметр("УзелПланаОбмена", Параметры.УзелОбмена);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если Выборка.ВидИнформационнойКартыСмешаннаяВУТ = Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
			СтрокаШтрихкода = РаботаСТорговымОборудованием.ПолучитьШтрихКод(Источник.Ссылка);
			Если СтрокаШтрихкода <> Неопределено Тогда
				Значение = СтрокаШтрихкода.ТипШтрихкода;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
Иначе
	
	Значение = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13;
	
КонецЕсли;
