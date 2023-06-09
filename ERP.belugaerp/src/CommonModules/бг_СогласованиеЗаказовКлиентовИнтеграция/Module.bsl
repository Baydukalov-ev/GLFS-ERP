
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.УстановитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		ВыгружаемыеРеквизиты());

КонецПроцедуры

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_обработчикиСобытийСтандартный;    
	адаптер_обработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_обработчикиСобытийСтандартный");
	
	СтруктураРезультат = адаптер_ОбработчикиСобытийСтандартный.ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения);

	ПараметрыВыполненияЗапросов = адаптер_РаботаСДаннымиИБ.ПолучитьПараметрыВыполненияЗапросов(Объект, ДанныеСообщения);
	
	ПроверятьДополнительныеУсловия = ДанныеСообщения.ДополнительныеСвойстваОбъекта.Свойство(                  
		"адаптер_ПроверятьДополнительныеУсловияПриПолученииДанныхВыгружаемогоОбъекта");
	
	Результат = адаптер_РаботаСДаннымиИБ.ПолучитьРезультатЗапроса(ПараметрыВыполненияЗапросов.ТекстыЗапросов.ТекстЗапроса,
		ПараметрыВыполненияЗапросов.ПараметрыЗапроса,
		ПараметрыВыполненияЗапросов.ТаблицаОтбора,
		ПроверятьДополнительныеУсловия);
		
	МассивРеквизиты = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(Результат,
		ПараметрыВыполненияЗапросов.ТаблицаКлючей, ДанныеСообщения);
		
	Если Не МассивРеквизиты.Количество() = 0 Тогда
		
		СтруктураДанных = МассивРеквизиты[0];
		ЗаказКлиента = XMLЗначение(Тип("ДокументСсылка.ЗаказКлиента"), МассивРеквизиты[0].ЗаказКлиента.Идентификатор);
		НастройкиСогласования = РегистрыСведений.бг_НастройкиСогласованияЗаказовКлиентов.НастройкиСогласования(ЗаказКлиента);
		СтруктураДанных.Вставить("ТребуетсяВизаСБ", НастройкиСогласования.ТребуетсяВизаСБ);
	КонецЕсли; 
	
	СтруктураРезультат.Вставить("Реквизиты", МассивРеквизиты);
	
	ДанныеСообщения.RoutingKey = КлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения, ПараметрыВыполненияЗапросов);

	Возврат СтруктураРезультат;
	
КонецФункции

Функция СоздатьНаборЗаписейРегистра(Отбор, ПолноеИмя) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	Перем адаптер_РаботаСДаннымиИБ;
	
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ЗаказКлиента = адаптер_РаботаСДаннымиИБ.НайтиСсылкуПоЗагружаемымДанным(Отбор.ЗаказПокупателя);
	
	НаборЗаписей = адаптер_ОбработчикиСобытийСтандартный.СоздатьНаборЗаписейРегистра(Отбор, ПолноеИмя);
	НаборЗаписей.Отбор.ЗаказКлиента.Установить(ЗаказКлиента);

	Если Не ЗначениеЗаполнено(ЗаказКлиента) Или Не ОбщегоНазначения.СсылкаСуществует(ЗаказКлиента) Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("СтандартнаяЗаписьНеТребуется", Истина);
		Возврат НаборЗаписей;
	КонецЕсли;
	
	ЗаказКлиентаОбъект = ЗаказКлиента.ПолучитьОбъект();
	УстановитьСтатусЗаказаКлиента(Отбор, ЗаказКлиентаОбъект);

	Если бг_КонстантыПовтИсп.ЗначениеКонстанты("ИспользоватьСогласованиеЗаказовПокупателей", 
		ЗаказКлиентаОбъект.Организация) Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("СтандартнаяЗаписьНеТребуется", Истина);
	КонецЕсли;

	Возврат НаборЗаписей;
	
КонецФункции

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	СтандартнаяОбработка = Ложь;

	СтруктураРеквизитовСоответствия = Новый Структура;
	СтруктураРеквизитовСоответствия.Вставить("ДатаПередачиВСборку", "ДатаЗаказПереданВСборку");
	СтруктураРеквизитовСоответствия.Вставить("ДатаСборки", "ДатаЗаказСобран");
	СтруктураРеквизитовСоответствия.Вставить("ДатаСогласованияКК", "ДатаСогласованияКредитнымКонтролером");
	СтруктураРеквизитовСоответствия.Вставить("ДатаСогласованияФК", "ДатаСогласованияФинансовымКонтролером");
	СтруктураРеквизитовСоответствия.Вставить("ДатаСогласованияСБ", "ДатаСогласованияСлужбойБезопасности");
	СтруктураРеквизитовСоответствия.Вставить("РезультатСогласования", "РезультатСогласование");
	СтруктураРеквизитовСоответствия.Вставить("РезультатСогласованияКК", "РезультатСогласованиеКредитнымКонтроллером");
	СтруктураРеквизитовСоответствия.Вставить("РезультатСогласованияФК", "РезультатСогласованиеФинансовымКонтроллером");
	СтруктураРеквизитовСоответствия.Вставить("РезультатСогласованияСБ", "РезультатСогласованиеСлужбойБезопасности");
	СтруктураРеквизитовСоответствия.Вставить("ЗаказКлиента", "ЗаказПокупателя");
	
	Для Каждого РеквизитСоответствия Из СтруктураРеквизитовСоответствия Цикл
	
		Если СтруктураОбъекта.Свойство(РеквизитСоответствия.Значение) Тогда
			СтруктураОбъекта.Вставить(РеквизитСоответствия.Ключ, СтруктураОбъекта[РеквизитСоответствия.Значение]);
		КонецЕсли;
	
	КонецЦикла;
	
	адаптер_ОбработчикиСобытийСтандартный.ЗаполнитьЗагружаемыйОбъект(
		ЗагружаемыйОбъект, 
		СтруктураОбъекта, 
		СписокСвойств, 
		ИсключаяСвойства);
	
КонецПроцедуры

Процедура ПередРегистрациейИсходящегоСообщения(Источник, НастройкиВыгрузки) Экспорт
	
	Если ЗначениеЗаполнено(Источник.Отбор)
		И Источник.Отбор.Найти("ЗаказКлиента") <> Неопределено
		И Не ВыгружатьОбъект(Источник.Отбор.ЗаказКлиента.Значение) Тогда
		Источник.ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Конец ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСтатусЗаказаКлиента(ДанныеОтбора, ДокументОбъект)
	
	Если Не бг_УчетАлкоголя.ЭтоЭкспортнаяПродажа(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОтбора.СодержитЗаписи 
		И ДанныеОтбора.Запись[0].Согласован Тогда
		
		ДокументОбъект.Согласован = Истина;
		ДокументОбъект.Статус = Перечисления.СтатусыЗаказовКлиентов.КОбеспечению;
		
	Иначе
		
		ДокументОбъект.Согласован = Ложь;
		ДокументОбъект.Статус = Перечисления.СтатусыЗаказовКлиентов.НеСогласован;
		
	КонецЕсли;
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина);
	Если ДокументОбъект.Проведен Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
КонецПроцедуры

Функция ВыгружаемыеРеквизиты()
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");

	ВыгружаемыеРеквизиты = Новый Массив;
	
	ВыгружаемыеРеквизиты.Добавить("ЗаказКлиента");

	// Ресурсы
	ВыгружаемыеРеквизиты.Добавить("ДатаПередачиВСборку");
	ВыгружаемыеРеквизиты.Добавить("ДатаСборки");
	ВыгружаемыеРеквизиты.Добавить("ДатаЗаказСобран");
	ВыгружаемыеРеквизиты.Добавить("ДатаСогласованияКК");
	ВыгружаемыеРеквизиты.Добавить("ДатаСогласованияСБ");
	ВыгружаемыеРеквизиты.Добавить("ДатаСогласованияФК");
	ВыгружаемыеРеквизиты.Добавить("Закрыт");
	ВыгружаемыеРеквизиты.Добавить("ПроцентВыполнения");
	ВыгружаемыеРеквизиты.Добавить("РезультатСогласованияКК");
	ВыгружаемыеРеквизиты.Добавить("РезультатСогласованияСБ");
	ВыгружаемыеРеквизиты.Добавить("РезультатСогласованияФК");
	ВыгружаемыеРеквизиты.Добавить("РезультатСогласования");

	// Реквизиты
	ВыгружаемыеРеквизиты.Добавить(адаптер_НастройкиОбмена.ОписаниеРеквизита(
		"КомментарийФК",
		Новый ОписаниеТипов("Строка"),
		"КомментарийФК"));
	ВыгружаемыеРеквизиты.Добавить(адаптер_НастройкиОбмена.ОписаниеРеквизита(
		"КомментарийКК",
		Новый ОписаниеТипов("Строка"),
		"КомментарийКК"));
	ВыгружаемыеРеквизиты.Добавить(адаптер_НастройкиОбмена.ОписаниеРеквизита(
		"КомментарийСБ",
		Новый ОписаниеТипов("Строка"),
		"КомментарийСБ"));
	
	// Добавляемые реквизиты
	ВыгружаемыеРеквизиты.Добавить(адаптер_НастройкиОбмена.ОписаниеРеквизита(
		"Организация",
		Новый ОписаниеТипов("СправочникСсылка.Организации"),
		"ЗаказКлиента.Организация"));

	ВыгружаемыеРеквизиты.Добавить(адаптер_НастройкиОбмена.ОписаниеРеквизита(
		"Дата",
		Новый ОписаниеТипов("Дата"),
		"ЗаказКлиента.Дата"));
		
	Возврат ВыгружаемыеРеквизиты;

КонецФункции

Функция ВыгружатьОбъект(ЗаказКлиента)
	Если ЗначениеЗаполнено(ЗаказКлиента) Тогда
		
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаказКлиента, "Организация");

		Возврат бг_КонстантыПовтИсп.ЗначениеКонстанты("ИспользоватьСогласованиеЗаказовПокупателей", Организация);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция КлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения, ПараметрыВыполненияЗапросов)
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	КлючМаршрутизации = адаптер_ОбработчикиСобытийСтандартный.ПолучитьКлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения);
	
	ПрефиксОрганизации = ПрефиксОрганизацииИзПараметровОтбора(ПараметрыВыполненияЗапросов);
	Если ЗначениеЗаполнено(ПрефиксОрганизации) Тогда
		КлючМаршрутизации = СтрШаблон("%1.%2", КлючМаршрутизации, ПрефиксОрганизации);
	КонецЕсли;
	
	Возврат КлючМаршрутизации;

КонецФункции

Функция ЗаказКлиентаИзПараметровОтбора(ПараметрыВыполненияЗапросов)
	
	ЗаказКлиента = Неопределено;
	
	Если ПараметрыВыполненияЗапросов.ТаблицаОтбора.Количество() > 0 Тогда
		ЗаказКлиента = ПараметрыВыполненияЗапросов.ТаблицаОтбора[0].ЗаказКлиента;
	КонецЕсли;
	
	Возврат ЗаказКлиента;
	
КонецФункции

Функция ПрефиксОрганизацииИзПараметровОтбора(ПараметрыВыполненияЗапросов)

	ЗаказКлиента = ЗаказКлиентаИзПараметровОтбора(ПараметрыВыполненияЗапросов);
	
	ПрефиксОрганизации = Неопределено;
	Если ЗначениеЗаполнено(ЗаказКлиента) Тогда
		ПрефиксОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаказКлиента, "Организация.Префикс");
	КонецЕсли;
	
	Возврат ПрефиксОрганизации;
	
КонецФункции

#КонецОбласти // Конец СлужебныеПроцедурыИФункции
