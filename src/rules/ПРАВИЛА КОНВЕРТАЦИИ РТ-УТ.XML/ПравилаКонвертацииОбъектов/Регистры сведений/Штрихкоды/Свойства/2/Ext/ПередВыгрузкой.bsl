﻿Если ТипЗнч(Источник.Владелец) = Тип("СправочникСсылка.ИнформационныеКарты") Тогда
	ИмяПКО = "ИнформационныеКарты";
Иначе
	ИмяПКО = "Номенклатура";
	Если ТипЗнч(Источник.Владелец) = Тип("СправочникСсылка.СерийныеНомера") Тогда
		Значение = Источник.Владелец.Владелец
	КонецЕсли;
КонецЕсли;
