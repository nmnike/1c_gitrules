﻿ПровестиЗаписьНеЗаписанныхОбъектов();

// Получим и установим значения некоторых параметров
Наименование    = СвойстваПоиска.Получить("Наименование");
Владелец        = СвойстваПоиска.Получить("Владелец");
СсылкаНаОбъект  = Неопределено;
ПрекратитьПоиск = Истина;

// Произведем поиск элемента вручную
Если ЗначениеЗаполнено(Владелец) Тогда
	
	СсылкаНаОбъект = Справочники.ХарактеристикиНоменклатуры.НайтиПоНаименованию(Наименование, Истина,, Владелец);
	
КонецЕсли;
