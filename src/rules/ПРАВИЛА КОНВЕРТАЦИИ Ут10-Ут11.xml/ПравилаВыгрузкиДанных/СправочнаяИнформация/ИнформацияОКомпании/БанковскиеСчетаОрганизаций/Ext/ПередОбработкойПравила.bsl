Запрос = Новый Запрос("
|ВЫБРАТЬ
|	БанковскиеСчета.Ссылка,
|	БанковскиеСчета.ПометкаУдаления,
|	БанковскиеСчета.Владелец,
|	БанковскиеСчета.Код,
|	БанковскиеСчета.Наименование,
|	БанковскиеСчета.НомерСчета,
|	БанковскиеСчета.Банк,
|	БанковскиеСчета.БанкДляРасчетов,
|	БанковскиеСчета.ТекстКорреспондента,
|	БанковскиеСчета.ТекстНазначения,
|	БанковскиеСчета.ВалютаДенежныхСредств,
|	БанковскиеСчета.СуммаБезКопеек КАК ВыводитьСуммуБезКопеек,
|	ВЫБОР КОГДА БанковскиеСчета.МесяцПрописью ТОГДА
|		""Прописью""
|	ИНАЧЕ
|		""Числом""
|	КОНЕЦ КАК ВариантВыводаМесяца
|ИЗ
|	Справочник.БанковскиеСчета КАК БанковскиеСчета
|ГДЕ
|	БанковскиеСчета.Владелец ССЫЛКА Справочник.Организации
|");

ВыборкаДанных = Запрос;
