
#Область ПрограммныйИнтерфейс

&Вместо("ПолучитьБлокируемыеРеквизитыОбъекта")
Функция бг_ПолучитьБлокируемыеРеквизитыОбъекта()
	Результат = ПродолжитьВызов();
	Результат.Добавить("бг_Накопительная");
	Результат.Добавить("бг_ОграничениеСкидки");
	
	Возврат Результат;
КонецФункции

// Готовит данные для отображения в форме
// Возвращает структуру с данными запросов
Функция бг_ПодготовитьДанныеВытесненияИнтерваловДействия(СкидкаНаценка) Экспорт
	
	ТекстыЗапросовПакета = бг_ТекстыЗапросаВременныхТаблицВытесненияИнтерваловДействия();
	ТекстыЗапросовПакета.Добавить(
		"ВЫБРАТЬ
		|	ИСТИНА           КАК ДетальнаяЗапись,
		|	Т.ДатаНачала2    КАК НачалоДействия,
		|	Т.ДатаОкончания2 КАК ОкончаниеДействия,
		|	ИСТИНА           КАК ВыполнитьВытеснение,
		|	""""             КАК Представление,
		|	Т.СкидкаНаценка1 КАК СкидкаНаценка,
		|	Т.Источник1      КАК Источник,
		|	Т.ДатаНачала1    КАК ДатаНачала,
		|	Т.ДатаОкончания1 КАК ДатаОкончания
		|ИЗ
		|	ВТ_ИнтервалыВытеснения Т
		|УПОРЯДОЧИТЬ ПО
		|	СкидкаНаценка, Источник, ДатаНачала, ДатаОкончания
		|ИТОГИ
		|	ЛОЖЬ ДетальнаяЗапись,
		|	ВЫБОР
		|		КОГДА Т.Источник1 ЕСТЬ НЕ NULL ТОГДА МИНИМУМ(ВыполнитьВытеснение)
		|		КОГДА Т.СкидкаНаценка1 ЕСТЬ НЕ NULL ТОГДА МАКСИМУМ(ВыполнитьВытеснение)
		|	КОНЕЦ ВыполнитьВытеснение,
		|	ВЫБОР
		|		КОГДА Т.Источник1 ЕСТЬ НЕ NULL ТОГДА ПРЕДСТАВЛЕНИЕ(Т.Источник1)
		|		КОГДА Т.СкидкаНаценка1 ЕСТЬ НЕ NULL ТОГДА ПРЕДСТАВЛЕНИЕ(Т.СкидкаНаценка1)
		|	КОНЕЦ Представление
		|ПО
		|	Т.СкидкаНаценка1, Т.Источник1"
	);
	ТекстыЗапросовПакета.Добавить(
		"ВЫБРАТЬ
		|	Т.Источник      КАК Источник,
		|	Т.ДатаНачала    КАК ДатаНачала,
		|	Т.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	ВТ_ПериодыДействияСкидкиНаценки КАК Т
		|
		|УПОРЯДОЧИТЬ ПО
		|	Т.Источник,
		|	Т.ДатаНачала,
		|	Т.ДатаОкончания"
	);
	
	Запрос = Новый Запрос(СтрСоединить(ТекстыЗапросовПакета, ОбщегоНазначения.РазделительПакетаЗапросов()));
	Запрос.УстановитьПараметр("СкидкаНаценка", СкидкаНаценка);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Данные = Новый Структура;
	
	Данные.Вставить("ПериодыДействия",          Результаты[Результаты.ВГраница() - 0].Выгрузить(ОбходРезультатаЗапроса.Прямой));
	Данные.Вставить("ВытесняемыеСкидкиНаценки", Результаты[Результаты.ВГраница() - 1].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам));
	
	Возврат Данные;
	
КонецФункции

// Вытесняет интервалы действия скидок/наценок
// Возвращает таблицу ошибок
//
// Параметры:
//  ВытесняемыеИнтервалыДействия - ТаблицаЗначений - таблица интервалов с колонками
//    * СкидкаНаценка     - СправочникСсылка.СкидкиНаценки
//    * Источник          - СправочникСсылка.Склады, СправочникСсылка.СоглашенияСКлиентами, СправочникСсылка.ВидыКартЛояльности,
//                          СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.битПунктыНазначения
//    * ДатаНачала        - Дата - Дата начала действия скидки СкидкаНаценка
//    * ДатаОкончания     - Дата - Дата окончания действия скидки СкидкаНаценка, может быть пустой
//    * НачалоДействия    - Дата - Дата начала действия вытесняющей скидки
//    * ОкончаниеДействия - Дата - Дата окончания действия вытесняющей скидки, может быть пустой
Функция бг_ВытеснитьИнтервалыДействия(ВходящиеДанные) Экспорт
	
	ИменаИзмерений = "СкидкаНаценка,Источник";
	
	Если ЭтоАдресВременногоХранилища(ВходящиеДанные) Тогда
		ВытесняемыеИнтервалыДействия = ПолучитьИзВременногоХранилища(ВходящиеДанные);
	ИначеЕсли ТипЗнч(ВходящиеДанные) = Тип("Строка") Тогда
		ВытесняемыеИнтервалыДействия = ОбщегоНазначения.ЗначениеИзСтрокиXML(ВходящиеДанные);
	Иначе
		ВытесняемыеИнтервалыДействия = ВходящиеДанные;
	КонецЕсли;
	
	ОшибкиВытеснения = Новый Массив;
	ОтборыЗаписей    = ВытесняемыеИнтервалыДействия.Скопировать(, ИменаИзмерений);
	Ответственный    = Пользователи.ТекущийПользователь();
	
	ОтборыЗаписей.Свернуть(ИменаИзмерений);
	
	НаборЗаписей = РегистрыСведений.ДействиеСкидокНаценок.СоздатьНаборЗаписей();
	Для каждого ОтборЗаписей из ОтборыЗаписей Цикл
		Попытка
			НачатьТранзакцию();
			
			НаборЗаписей.Очистить();
			НаборЗаписей.Отбор.Сбросить();
			
			ОтборСтрок = Новый Структура(ИменаИзмерений);
			ЗаполнитьЗначенияСвойств(ОтборСтрок, ОтборЗаписей);
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДействиеСкидокНаценок");
			Для каждого ЭлементОтбора из ОтборСтрок Цикл
				ЭлементБлокировки.УстановитьЗначение(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
				НаборЗаписей.Отбор[ЭлементОтбора.Ключ].Установить(ЭлементОтбора.Значение);
			КонецЦикла;
			Блокировка.Заблокировать();
			
			НаборЗаписей.Прочитать();
			
			Вытеснения = ВытесняемыеИнтервалыДействия.НайтиСтроки(ОтборСтрок);
			Для каждого Вытеснение из Вытеснения Цикл
				бг_ОбработатьИнтервал(Вытеснение, НаборЗаписей, ОтборСтрок, Ответственный);
			КонецЦикла;
			
			Если НаборЗаписей.Модифицированность() Тогда
				бг_ПроверитьОбработатьДубли(НаборЗаписей);
				
				НаборЗаписей.Записать(Истина);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ОтборСтрок.Вставить("Ошибка", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОшибкиВытеснения.Добавить(ОтборСтрок);
		КонецПопытки;
	КонецЦикла;
	
	Возврат ОшибкиВытеснения;
	
КонецФункции

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
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
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

// сравнить границы интервалов и определить действия
Процедура бг_ОбработатьИнтервал(Вытеснение, НаборЗаписей, ЗначенияЗаполнения, Ответственный)
	
	Перем Запись, УдаляемыеЗаписи;
	
	Если Вытеснение.ДатаНачала < Вытеснение.НачалоДействия Тогда
		// левый конец вытесняемого интервала строго левее левого конца вытесняющего интервала
		// вставить правый конец вытесняемого интервала равный левому концу вытесняющего
		ДействиеСлева = "Вставить";
	Иначе
		// левый конец вытесняемого интервала правее левого конца вытесняющего интервала
		// удалить левый конец вытесняемого интервала или сдвинуть его до правого конца вытесняющего
		ДействиеСлева = "Удалить";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Вытеснение.ОкончаниеДействия) Тогда
		// правый конец вытесняющего интервала закрытый
		Если Вытеснение.ДатаОкончания < Вытеснение.ОкончаниеДействия
			И ЗначениеЗаполнено(Вытеснение.ДатаОкончания) Тогда
			// правый конец вытесняемого интервала строго левее правого конца вытесняющего
			// удалить правый конце вытесняемого интервала или сдвинуть его до левого конца вытесняющего
			ДействиеСправа = "Удалить";
		Иначе
			// правый конец вытесняемого интервала правее правого конца вытесняющего
			// вставить левый конец вытесняемого интервала равный правому концу вытесняющего
			// ВКЛЮЧАЕТ СЛУЧАЙ ОТКРЫТОГО ПРАВОГО КОНЦА ВЫТЕСНЯЕМОГО ИНТЕРВАЛА
			ДействиеСправа = "Вставить";
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Вытеснение.ДатаОкончания) Тогда
		// правый конец вытесняющего интервала открытый, вытесняемого -- закрытый
		ДействиеСправа = "Удалить";
	Иначе
		// правые концы интервалов открытые
		// вставить правый конец вытесняющего интервала равный левому концу вытесняющего
		ДействиеСправа = "Вставить";
	КонецЕсли;
	
	Если ДействиеСлева = "Удалить" Тогда
		Если ДействиеСлева = ДействиеСправа Тогда
			// Удалить, Удалить
			// удалить и начало, и окончание
			УдаляемыеЗаписи = Новый Массив;
			Для каждого Запись из НаборЗаписей Цикл
				Если Запись.Период = Вытеснение.ДатаНачала Тогда
					УдаляемыеЗаписи.Добавить(Запись);
				ИначеЕсли Запись.Период = Вытеснение.ДатаОкончания + 86400 Тогда
					УдаляемыеЗаписи.Добавить(Запись);
				КонецЕсли;
			КонецЦикла;
			Для каждого Запись из УдаляемыеЗаписи Цикл
				НаборЗаписей.Удалить(Запись);
			КонецЦикла;
		Иначе
			// Удалить, Вставить
			// сдвинуть левый конец вытесняемого вправо за правый конец вытесняющего
			// то есть исправить начало вытесняемого интервала
			Для каждого Запись из НаборЗаписей Цикл
				Если Запись.Период = Вытеснение.ДатаНачала Тогда
					Запись.Период = Вытеснение.ОкончаниеДействия + 86400;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Если ДействиеСлева = ДействиеСправа Тогда
			// Вставить, Вставить
			// сделать "дырку", вставить окончание и начало
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, ЗначенияЗаполнения);
			Запись.Период = Вытеснение.НачалоДействия;
			Запись.Статус = Перечисления.СтатусыДействияСкидок.НеДействует;
			Запись.Ответственный = Ответственный;
			Запись.Комментарий   = НСтр("ru = 'Вытеснение'; en = 'Displacement'");
			Если ЗначениеЗаполнено(Вытеснение.ОкончаниеДействия) Тогда
				// если вытесняющий интервал с открытым концом,
				// вытесняемая скидка не начнёт действовать
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, ЗначенияЗаполнения);
				Запись.Период = Вытеснение.ОкончаниеДействия + 86400;
				Запись.Статус = Перечисления.СтатусыДействияСкидок.Действует;
				Запись.Ответственный = Ответственный;
				Запись.Комментарий   = НСтр("ru = 'Вытеснение'; en = 'Displacement'");
			КонецЕсли;
		Иначе
			// Вставить, Удалить
			// сдвинуть правый конец вытесняемого влево за левый конец вытесняющего
			// то есть исправить конце вытесняемого интервала
			Для каждого Запись из НаборЗаписей Цикл
				Если Запись.Период = Вытеснение.ДатаОкончания + 86400 Тогда
					Запись.Период = Вытеснение.НачалоДействия;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция бг_ТаблицаКонтроляДублей(Таблица, ОтборСтрок = Неопределено, ИменаКолонок)
	
	Если ТипЗнч(Таблица) <> Тип("ТаблицаЗначений") И ОтборСтрок <> Неопределено Тогда
		СтрокиТаблицы = Новый Массив;
		Для каждого СтрокаТаблицы из Таблица Цикл
			УдовлетворяетОтбору = ОтборСтрок.Количество() > 0;
			Для каждого ЭлементОтбора из ОтборСтрок Цикл
				УдовлетворяетОтбору = УдовлетворяетОтбору И СтрокаТаблицы[ЭлементОтбора.Ключ] = ЭлементОтбора.Значение;
			КонецЦикла;
			Если УдовлетворяетОтбору Тогда
				СтрокиТаблицы.Добавить(СтрокаТаблицы);
			КонецЕсли;
		КонецЦикла;
	Иначе
		СтрокиТаблицы = ОтборСтрок;
	КонецЕсли;
	
	ТаблицаДублей = Таблица.Выгрузить(СтрокиТаблицы, ИменаКолонок);
	ТаблицаДублей.Колонки.Добавить("Колво", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаДублей.ЗаполнитьЗначения(1, "Колво");
	ТаблицаДублей.Свернуть(ИменаКолонок, "Колво");
	
	УдаляемыеСтроки = ТаблицаДублей.НайтиСтроки(Новый Структура("Колво", 1));
	Для каждого СтрокаТаблицы из УдаляемыеСтроки Цикл
		ТаблицаДублей.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
	Возврат ТаблицаДублей;
	
КонецФункции

Процедура бг_ПроверитьОбработатьДубли(НаборЗаписей)
	
	КонтрольДублей = бг_ТаблицаКонтроляДублей(НаборЗаписей,, "Период");
	Если КонтрольДублей.Количество() Тогда
		// попытка поудалять бессмысленные строки
		//  - если статус одинаковый -- оставить одну строку
		//  - если статусы разные -- удалить обе
		Для каждого Вытеснение из КонтрольДублей Цикл
			ЗаписиДублей = бг_ТаблицаКонтроляДублей(НаборЗаписей, Новый Структура("Период", Вытеснение.Период), "Статус");
			УдаляемыеЗаписи = Новый Массив;
			Для каждого Запись из НаборЗаписей Цикл
				Если Запись.Период = Вытеснение.Период Тогда
					УдаляемыеЗаписи.Добавить(Запись);
				КонецЕсли;
			КонецЦикла;
			
			Если ЗаписиДублей.Количество() = 1 Тогда
				// один и тот же статус, оставить одну строку
				УдаляемыеЗаписи.Удалить(0);
			ИначеЕсли ЗаписиДублей.Количество() = 2 Тогда
				Если ЗаписиДублей.Итог("Колво") % 2 Тогда
					// суммарное количество разных статусов -- нечётное
					// неизвестно, что удалять, доведём до ошибки
					УдаляемыеЗаписи.Очистить();
				КонецЕсли;
			КонецЕсли;
			
			Для каждого Запись из УдаляемыеЗаписи Цикл
				НаборЗаписей.Удалить(Запись);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция бг_ТекстыЗапросаВременныхТаблицВытесненияИнтерваловДействия()
	
	ТекстыЗапросовПакета = Новый Массив;
	
	// периоды действия вытесняющей скидки/наценки
	ТекстыЗапросовПакета.Добавить(
		бг_РасчетСкидок.ТекстЗапросаИнтервалыДействияСкидокНаценок(
			"ВТ_ПериодыДействияСкидкиНаценки",       // имя таблицы интервалов действия
			"РегистрСведений.ДействиеСкидокНаценок", // имя таблицы статусов
			"= &СкидкаНаценка"                       // условие отбора скидки/наценки
		)
	);
	
	// подготовка таблицы статусов за периоды действия вытесняющей скидки
	
	// период отбора записей регистра -- наименьшее покрытие периодов действия
	ТекстыЗапросовПакета.Добавить(
		"ВЫБРАТЬ
		|	МИНИМУМ(ДатаНачала) КАК ДатаНачала,
		|	ВЫБОР МАКСИМУМ(ЕСТЬNULL(ДатаОкончания, ДАТАВРЕМЯ(3999, 12, 31, 23, 59, 59)))
		|		КОГДА ДАТАВРЕМЯ(3999, 12, 31, 23, 59, 59) ТОГДА NULL
		|		ИНАЧЕ МАКСИМУМ(ДатаОкончания)
		|	КОНЕЦ КАК ДатаОкончания
		|ПОМЕСТИТЬ ВТ_ИнтервалОтбораРегистра
		|ИЗ
		|	ВТ_ПериодыДействияСкидкиНаценки Т"
	);
	
	// срез на начало периода отбора записей
	ТекстыЗапросовПакета.Добавить(
		"ВЫБРАТЬ
		|	МАКСИМУМ(Период) КАК Период,
		|	СкидкаНаценка    КАК СкидкаНаценка,
		|	Источник         КАК Источник
		|
		|ПОМЕСТИТЬ ВТ_СрезВходящих
		|ИЗ
		|	РегистрСведений.ДействиеСкидокНаценок Р
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИнтервалОтбораРегистра Т
		|		ПО Р.Период <= Т.ДатаНачала
		|			И Р.СкидкаНаценка <> &СкидкаНаценка
		|
		|СГРУППИРОВАТЬ ПО
		|	СкидкаНаценка, Источник
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СкидкаНаценка, Источник, МАКСИМУМ(Период)"
	);
	
	// таблица статусов
	ТекстыЗапросовПакета.Добавить(
		"ВЫБРАТЬ
		|	Период, СкидкаНаценка, Источник, Статус
		|
		|ПОМЕСТИТЬ ВТ_ДанныеРегистра
		|ИЗ
		|	РегистрСведений.ДействиеСкидокНаценок Р
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИнтервалОтбораРегистра Т
		|		ПО Р.Период МЕЖДУ Т.ДатаНачала И ЕСТЬNULL(ДОБАВИТЬКДАТЕ(Т.ДатаОкончания, ДЕНЬ, 1), Р.Период)
		|			И Р.СкидкаНаценка <> &СкидкаНаценка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Р.Период, Р.СкидкаНаценка, Р.Источник, Статус
		|
		|ИЗ
		|	РегистрСведений.ДействиеСкидокНаценок Р
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СрезВходящих Т
		|	ПО Р.Период = Т.Период
		|		И Р.СкидкаНаценка = Т.СкидкаНаценка
		|		И Р.Источник = Т.Источник
		|		И Р.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДействияСкидок.Действует)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СкидкаНаценка, Статус, Источник, Период"
	);
	
	ТекстыЗапросовПакета.Добавить("УНИЧТОЖИТЬ ВТ_СрезВходящих");
	
	ТекстыЗапросовПакета.Добавить("УНИЧТОЖИТЬ ВТ_ИнтервалОтбораРегистра");
	
	// периоды действия остальных скидок/наценок
	ТекстыЗапросовПакета.Добавить(
		бг_РасчетСкидок.ТекстЗапросаИнтервалыДействияСкидокНаценок(
			"ВТ_ПериодыДействияСкидокНаценок",  // имя таблицы интервалов действия
			"ВТ_ДанныеРегистра",                // имя таблицы статусов
			" <> &СкидкаНаценка"                // условие отбора скидки/наценки
		)
	);
	
	// пересекающиеся периоды действия скидок/наценок
	ТекстыЗапросовПакета.Добавить(
		бг_РасчетСкидок.ТекстЗапросаПересеченияИнтерваловДействия(
			"ВТ_ИнтервалыВытеснения",
			"ВТ_ПериодыДействияСкидокНаценок",  // имя таблицы вытесняющих интервалов
			"ВТ_ПериодыДействияСкидкиНаценки"   // имя таблицы вытесняемых интервалов
		)
	);
	
	Возврат ТекстыЗапросовПакета;
	
КонецФункции

Функция бг_ТекстЗапросаЗагружаемыхДанных(ДополнительныеПараметры)

	ИсточникГруппы = ?(ДополнительныеПараметры.Свойство("ИсточникГруппы"), 
		ДополнительныеПараметры.ИсточникГруппы, Перечисления.бг_ИсточникиЦеновойГруппы.SKU_MT);

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ЗагружаемыеДанные.ЦеноваяГруппа КАК ЦеноваяГруппа,
	|	ЗагружаемыеДанные.ЗначениеСкидкиНаценки КАК ЗначениеСкидкиНаценки
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
	|	ЗагружаемыеДанные.ЗначениеСкидкиНаценки КАК ЗначениеСкидкиНаценки,
	|	ВтЦеновыеГруппы.КоличествоЦеновыхГрупп КАК КоличествоЦеновыхГрупп
	|ИЗ
	|	ВтЗагружаемыеДанные КАК ЗагружаемыеДанные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтЦеновыеГруппы КАК ВтЦеновыеГруппы
	|		ПО (ВтЦеновыеГруппы.Идентификатор = ЗагружаемыеДанные.Идентификатор)";
	
	Если ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.SKU_MT
		И ДополнительныеПараметры.Свойство("SKU_MT_Номенклатура") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ОБЪЕДИНИТЬ ВСЕ", 
		"ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЗагружаемыеДанные.Идентификатор,
		|		Справочник.Ссылка
		|	ИЗ
		|		ВтЗагружаемыеДанные КАК ЗагружаемыеДанные
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Справочник
		|			ПО (Справочник.Наименование = ЗагружаемыеДанные.ЦеноваяГруппа)
		|
		|ОБЪЕДИНИТЬ ВСЕ");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Номенклатура Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.Номенклатура");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.BrandMT Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.бг_ЕК_Бренды_БрендыМТ");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.BrandTM Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.бг_ЕК_Бренды_БрендыТМ");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Вкус Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.бг_ЕК_СКЮ_Вкусы");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Класс Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.бг_ЕК_СКЮ_Классы");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Проект Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.Проекты");
	ИначеЕсли ИсточникГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.ЦеноваяГруппа Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.бг_ЕК_СКЮ_СкюМТ", "Справочник.ЦеновыеГруппы");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Код = ЗагружаемыеДанные.ЦеноваяГруппа", "ЛОЖЬ");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
