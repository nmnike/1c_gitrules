﻿Если Источник.ВидКарты = Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
	
	НаборЗаписейШтриходов = РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
	НаборЗаписейШтриходов.Отбор.Владелец.Установить(Источник.Ссылка);
	НаборЗаписейШтриходов.Прочитать();
	Если НаборЗаписейШтриходов.Количество() > 0 Тогда
		Значение = НаборЗаписейШтриходов[0].Штрихкод;
	Иначе
		Значение = "";
	КонецЕсли;
	
КонецЕсли;
