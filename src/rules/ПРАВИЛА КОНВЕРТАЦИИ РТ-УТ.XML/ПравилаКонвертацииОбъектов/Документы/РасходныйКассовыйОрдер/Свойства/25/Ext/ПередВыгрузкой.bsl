﻿Если Не ЗначениеЗаполнено(Источник.Касса) Или Источник.Касса = Перечисления.ТипыКасс.КассаЦентральногоОфиса Тогда
	Значение = "";
Иначе
	Значение = Источник.Касса.Магазин.Код;
КонецЕсли;
