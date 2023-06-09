#Область ПрограммныйИнтерфейс

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
// 
// Параметры:
// 	АдресЗагружаемыхДанных- Строка - адрес временного хранилища с таблицей значений, в которой
//                                   находятся загруженные данные из файла.
// 	АдресТаблицыСопоставления - Строка - адрес временного хранилища с пустой таблицей значений,
//                                       являющейся копией табличной части документа, 
//                                       которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
// 	СписокНеоднозначностей - ТаблицаЗначений - состоит из:
//  * Идентификатор - Число - идентификатор
//  * Колонка - Строка - имя колонки
// 	ПолноеИмяТабличнойЧасти - Строка - полное имя табличной части
// 	ДополнительныеПараметры - Структура - дополнительные параметры, переданные из формы-источнике.
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, 
	СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	ТаблицыСопоставления = ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);// ТаблицаЗначений
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	Запрос = Новый Запрос;
	Запрос.Текст = бг_ТекстЗапросаЗагружаемыхДанных(ДополнительныеПараметры);
	Запрос.УстановитьПараметр("ЗагружаемыеДанные", ЗагружаемыеДанные);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицыСопоставления.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если Выборка.КоличествоЦеновыхГрупп > 1 Тогда
			ЗаписьОНеоднозначности               = СписокНеоднозначностей.Добавить();
			ЗаписьОНеоднозначности.Идентификатор = Выборка.Идентификатор;
			ЗаписьОНеоднозначности.Колонка       = "ЦеноваяГруппа";
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТаблицыСопоставления, АдресТаблицыСопоставления);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция бг_ТекстЗапросаЗагружаемыхДанных(ДополнительныеПараметры)

	ИсточникГруппы = ?(ДополнительныеПараметры.Свойство("ИсточникГруппы"), 
		ДополнительныеПараметры.ИсточникГруппы, Перечисления.бг_ИсточникиЦеновойГруппы.SKU_MT);

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ЗагружаемыеДанные.ЦеноваяГруппа КАК ЦеноваяГруппа,
	|	ЗагружаемыеДанные.МаксимальнаяЕмкостьЕдиницы КАК МаксимальнаяЕмкостьЕдиницы,
	|	ЗагружаемыеДанные.МаксимальноеКоличествоЕдиниц КАК МаксимальноеКоличествоЕдиниц,
	|	ЗагружаемыеДанные.МинимальнаяЕмкостьЕдиницы КАК МинимальнаяЕмкостьЕдиницы,
	|	ЗагружаемыеДанные.МинимальноеКоличествоДекалитров КАК МинимальноеКоличествоДекалитров,
	|	ЗагружаемыеДанные.МинимальноеКоличествоЕдиниц КАК МинимальноеКоличествоЕдиниц
	|ПОМЕСТИТЬ ВтЗагружаемыеДанные
	|ИЗ
	|	&ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|ГДЕ
	|	НЕ ЗагружаемыеДанные.ЦеноваяГруппа = """"
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеновыеГруппы.Идентификатор КАК Идентификатор,
	|	МАКСИМУМ(ЦеновыеГруппы.ЦеноваяГруппа) КАК ЦеноваяГруппа,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЦеновыеГруппы.ЦеноваяГруппа) КАК КоличествоЦеновыхГрупп
	|ПОМЕСТИТЬ ВтЦеновыеГруппы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|		Справочник.Ссылка КАК ЦеноваяГруппа
	|	ИЗ
	|		ВтЗагружаемыеДанные КАК ЗагружаемыеДанные
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.бг_ЕК_СКЮ_СкюМТ КАК Справочник
	|			ПО (Справочник.Код = ЗагружаемыеДанные.ЦеноваяГруппа)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗагружаемыеДанные.Идентификатор,
	|		Справочник.Ссылка
	|	ИЗ
	|		ВтЗагружаемыеДанные КАК ЗагружаемыеДанные
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.бг_ЕК_СКЮ_СкюМТ КАК Справочник
	|			ПО (Справочник.Наименование = ЗагружаемыеДанные.ЦеноваяГруппа)) КАК ЦеновыеГруппы
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦеновыеГруппы.Идентификатор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ВтЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа,
	|	ЗагружаемыеДанные.МаксимальнаяЕмкостьЕдиницы КАК МаксимальнаяЕмкостьЕдиницы,
	|	ЗагружаемыеДанные.МаксимальноеКоличествоЕдиниц КАК МаксимальноеКоличествоЕдиниц,
	|	ЗагружаемыеДанные.МинимальнаяЕмкостьЕдиницы КАК МинимальнаяЕмкостьЕдиницы,
	|	ЗагружаемыеДанные.МинимальноеКоличествоДекалитров КАК МинимальноеКоличествоДекалитров,
	|	ЗагружаемыеДанные.МинимальноеКоличествоЕдиниц КАК МинимальноеКоличествоЕдиниц,
	|	ВтЦеновыеГруппы.КоличествоЦеновыхГрупп КАК КоличествоЦеновыхГрупп
	|ИЗ
	|	ВтЗагружаемыеДанные КАК ЗагружаемыеДанные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтЦеновыеГруппы КАК ВтЦеновыеГруппы
	|		ПО (ВтЦеновыеГруппы.Идентификатор = ЗагружаемыеДанные.Идентификатор)";
	
	ПодстрокаПоиска = "Справочник.бг_ЕК_СКЮ_СкюМТ";
	Если ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Номенклатура Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.Номенклатура");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.BrandMT Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.бг_ЕК_Бренды_БрендыМТ");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.BrandTM Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.бг_ЕК_Бренды_БрендыТМ");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Вкус Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.бг_ЕК_СКЮ_Вкусы");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Класс Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.бг_ЕК_СКЮ_Классы");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Проект Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.Проекты");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.ЦеноваяГруппа Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПодстрокаПоиска, "Справочник.ЦеновыеГруппы");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Код = ЗагружаемыеДанные.ЦеноваяГруппа", "ЛОЖЬ");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
