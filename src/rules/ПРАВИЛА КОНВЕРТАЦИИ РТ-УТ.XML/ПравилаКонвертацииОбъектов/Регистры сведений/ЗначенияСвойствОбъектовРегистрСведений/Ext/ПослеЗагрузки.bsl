﻿ПровестиЗаписьНеЗаписанныхОбъектов();

// Получим наименование характеристики товара и список всех ее владельцев
Если ПараметрыОбъекта <> Неопределено Тогда
	
	НаименованиеХарактеристикиНоменклатуры = ПараметрыОбъекта["НаименованиеХарактеристикиНоменклатуры"];
	
	Попытка
		ВладельцыХарактеристики = ЗначениеИзСтрокиВнутр(ПараметрыОбъекта["ВладельцыХарактеристики"]);
	Исключение
		ВладельцыХарактеристики = Новый Массив;
	КонецПопытки;
	
	Если НРег(СокрЛП(НаименованиеХарактеристикиНоменклатуры)) = "не назначена" Тогда
		
		Объект.Очистить();
		
	Иначе
		// Производим поиск характеристики товара
		Если НЕ(ЗначениеЗаполнено(Объект.Отбор.Объект.Значение) ИЛИ ПустаяСтрока(НаименованиеХарактеристикиНоменклатуры)) И ТипЗнч(ВладельцыХарактеристики)=Тип("Массив") Тогда
			
			// Получим характеристику для каждого владельца
			Для каждого ТекСтрока Из ВладельцыХарактеристики Цикл
				
				// Восстанавливаем значение текущего владельца характеристики
				Владелец = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ТекСтрока));
				
				// Найдем соответствующую характеристику
				ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.НайтиПоНаименованию(НаименованиеХарактеристикиНоменклатуры, Истина,, Владелец);
				
				// Если не удалось найти - создаем новый элемент
				Если НЕ ЗначениеЗаполнено(ХарактеристикаНоменклатуры) И ЗначениеЗаполнено(Владелец) Тогда
					
					ХарактеристикаНоменклатурыОбъект = Справочники.ХарактеристикиНоменклатуры.СоздатьЭлемент();
					ХарактеристикаНоменклатурыОбъект.Владелец     = Владелец;
					ХарактеристикаНоменклатурыОбъект.Наименование = НаименованиеХарактеристикиНоменклатуры;
					ХарактеристикаНоменклатурыОбъект.ОбменДанными.Загрузка = Истина;
					ХарактеристикаНоменклатурыОбъект.Записать();
					ХарактеристикаНоменклатуры = ХарактеристикаНоменклатурыОбъект.Ссылка;
					
				КонецЕсли;
				
				// Внесем изменения в параметры набора записей и произведем его запись
				Если ЗначениеЗаполнено(ХарактеристикаНоменклатуры) Тогда
					
					Объект.Отбор.Объект.Установить(ХарактеристикаНоменклатуры, Истина);
					Для каждого Запись Из Объект Цикл
						Запись.Объект = ХарактеристикаНоменклатуры;
					КонецЦикла;
					
					Объект.ОбменДанными.Загрузка = Истина;
					Объект.Записать(Истина);
					
				КонецЕсли;
				
			КонецЦикла;
			
			// Если не удалось восстановить значения характеристик, то не будем загружать такой набор
			Если ВладельцыХарактеристики.Количество()=0 И НЕ ЗначениеЗаполнено(Объект.Отбор.Объект.Значение) Тогда
				
				Объект.Очистить();
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
КонецЕсли;
