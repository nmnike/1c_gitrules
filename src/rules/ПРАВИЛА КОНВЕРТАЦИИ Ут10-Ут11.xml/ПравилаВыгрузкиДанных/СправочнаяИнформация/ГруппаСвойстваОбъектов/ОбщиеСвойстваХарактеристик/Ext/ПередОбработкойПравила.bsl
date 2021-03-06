Запрос = Новый Запрос("
|ВЫБРАТЬ
|	СвойстваОбъектов.Ссылка КАК Свойство
|ИЗ
|	ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
|ГДЕ
|	СвойстваОбъектов.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры)
|	И (НЕ СвойстваОбъектов.Ссылка В
|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
|					НазначенияСвойствОбъектов.Свойство
|				ИЗ
|					РегистрСведений.НазначенияСвойствОбъектов КАК НазначенияСвойствОбъектов))
|");

РезультатЗапроса = Запрос.Выполнить();	

ВыборкаДанных = Новый ТаблицаЗначений;
ВыборкаДанных.Колонки.Добавить("Наименование");
ВыборкаДанных.Колонки.Добавить("ПометкаУдаления");
ВыборкаДанных.Колонки.Добавить("ПредопределенныйЭлемент");
ВыборкаДанных.Колонки.Добавить("Родитель");
ВыборкаДанных.Колонки.Добавить("ДополнительныеРеквизиты");

НоваяСтрока = ВыборкаДанных.Добавить();
НоваяСтрока.Наименование = "Справочник ""Характеристики номенклатуры"" (Общие)";
НоваяСтрока.ПредопределенныйЭлемент = "Справочник_Номенклатура_Общие";
НоваяСтрока.ПометкаУдаления = Ложь;
НоваяСтрока.Родитель = "Справочник_ХарактеристикиНоменклатуры";
НоваяСтрока.ДополнительныеРеквизиты = Новый ТаблицаЗначений;
НоваяСтрока.ДополнительныеРеквизиты.Колонки.Добавить("Свойство");

Выборка = РезультатЗапроса.Выбрать();
Пока Выборка.Следующий() Цикл
	
	НовоеСвойство = НоваяСтрока.ДополнительныеРеквизиты.Добавить();
	НовоеСвойство.Свойство = Выборка.Свойство;
	
КонецЦикла;
