#Область ПрограммныйИнтерфейс

Функция НайтиСсылкуПоЗагружаемымДанным(СтруктураОбъекта) Экспорт
	
	Если СтруктураОбъекта = Неопределено Тогда
		Возврат Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	КонецЕсли;
	
	Если СтруктураОбъекта.Свойство("Код") Тогда
		Ссылка = бг_ОбщегоНазначенияСервер.СсылкаНаКлассификатор(СтруктураОбъекта, "Код");
	КонецЕсли;
	
	Возврат Ссылка;
	
КонецФункции

Процедура ЗаполнитьМассивПроверяемыхРеквизитовБлокировки(МетаданныеОбъекта, МассивПроверяемыхРеквизитов, СтандартнаяОбработка) Экспорт
	
	МассивПроверяемыхРеквизитов.Добавить("Код");
	МассивПроверяемыхРеквизитов.Добавить("Наименование");
	МассивПроверяемыхРеквизитов.Добавить("ПометкаУдаления");
	МассивПроверяемыхРеквизитов.Добавить("Предопределенный");

КонецПроцедуры

Функция ЗагрузитьОбъектИзОбъектаЕК_СтатьиДиР(СтруктураОбъектаЕК_СтатьиДиР) Экспорт
	
	ИдентификаторСтатьиДвиженияДенежныхСредств = бг_ОбщегоНазначенияСервер.ИдентификаторСУчетомТаблицыКлючей(СтруктураОбъектаЕК_СтатьиДиР.Идентификатор, "Справочник.СтатьиДвиженияДенежныхСредств");
	
	Ссылка = Справочники.СтатьиДвиженияДенежныхСредств.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторСтатьиДвиженияДенежныхСредств));
	СсылкаОбъект = Ссылка.ПолучитьОбъект();
	
	Если СсылкаОбъект = Неопределено Тогда
		СсылкаОбъект = Справочники.СтатьиДвиженияДенежныхСредств.СоздатьЭлемент();
		СсылкаОбъект.УстановитьСсылкуНового(Ссылка);
	КонецЕсли;
	
	Если СсылкаОбъект.ЭтоНовый() Тогда
		СсылкаОбъект.Заполнить(Неопределено);
	КонецЕсли;
	
	СсылкаОбъект.ПометкаУдаления = СтруктураОбъектаЕК_СтатьиДиР.ПометкаУдаления;
	СсылкаОбъект.Наименование = СтруктураОбъектаЕК_СтатьиДиР.Наименование;
	СсылкаОбъект.Код = СтруктураОбъектаЕК_СтатьиДиР.Код;
	
	СсылкаОбъект.ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина);
	
	СсылкаОбъект.Записать();
	
	Возврат СсылкаОбъект;
	
КонецФункции

#КонецОбласти