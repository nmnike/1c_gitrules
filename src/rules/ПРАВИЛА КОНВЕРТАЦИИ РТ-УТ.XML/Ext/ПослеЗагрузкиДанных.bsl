НаборЗаписей = РегистрыСведений.ОбъектыЗапрещенныеДляРедактирования.СоздатьНаборЗаписей();
Для Каждого СтрокаТаблицы Из Параметры.ТаблицаОбъектовЗапрещенныхДляРедактирования Цикл
	
	НаборЗаписей.Очистить();

	НаборЗаписей.Отбор.Ссылка.Установить(СтрокаТаблицы.Ссылка);
	
	НоваяЗапись        = НаборЗаписей.Добавить();
	НоваяЗапись.Ссылка = СтрокаТаблицы.Ссылка;
	
	НаборЗаписей.Записать();
	
КонецЦикла;

НаборЗаписей = РегистрыСведений.ОбъектыЗапрещенныеДляРедактирования.СоздатьНаборЗаписей();
Для Каждого СтрокаТаблицы Из Параметры.ТаблицаОбъектовРазрешенныхДляРедактирования Цикл
	
	НаборЗаписей.Отбор.Ссылка.Установить(СтрокаТаблицы.Ссылка);
	НаборЗаписей.Записать();
	
КонецЦикла;
