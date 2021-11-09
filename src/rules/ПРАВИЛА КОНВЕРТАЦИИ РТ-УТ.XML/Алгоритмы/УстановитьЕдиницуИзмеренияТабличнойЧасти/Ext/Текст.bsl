﻿ТаблицаКодовЕИ = ПараметрыОбъекта[ИмяТабличнойЧасти + "ТабличнаяЧасть"];

Для Каждого СтрокаТовары Из Объект[ИмяТабличнойЧасти] Цикл
	
	// так как могут передаться единицы измерения номенклатур-характеристик (что не нужно),
	//выгружаем только коды единиц измерения, а потом по ним находим нужную единицу
	НужнаяЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.НайтиПоКоду(ТаблицаКодовЕИ[СтрокаТовары.НомерСтроки - 1].КодЕдиницыИзмерения
																					 ,,, СтрокаТовары.Номенклатура);
	СтрокаТовары.ЕдиницаИзмерения = НужнаяЕдиницаИзмерения;
КонецЦикла;
