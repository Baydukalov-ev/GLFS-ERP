#Область ПрограммныйИнтерфейс

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_обработчикиСобытийСтандартный;
	адаптер_обработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_обработчикиСобытийСтандартный");
	
	ДанныеОбъекта = адаптер_обработчикиСобытийСтандартный.ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения);
	РеквизитыОбъекта = ДанныеОбъекта.Реквизиты[0];
	
	Если Объект.ВидДокумента = Перечисления.бг_ВидыМаршрутныхЛистов.МаршрутныйЛист Тогда
		РеквизитыОбъекта.Вставить("ПлановаяДатаОтгрузки", 
			ПлановаяДатаОтгрузкиМаршрутногоЛиста(Объект));
	ИначеЕсли Объект.ВидДокумента = Перечисления.бг_ВидыМаршрутныхЛистов.Рейс Тогда
		СтатусРейса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "СтатусРейса");
		ДатаИзмененияСтатуса = Документы.битМаршрутныйЛист.ДатаУстановкиСтатусаРейса(Объект, СтатусРейса);
		Если ДатаИзмененияСтатуса <> Неопределено Тогда
			РеквизитыОбъекта.Вставить("ДатаИзмененияСтатусаРейса", ДатаИзмененияСтатуса);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт		
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Реквизиты = ВыгружаемыеРеквизиты();
	ДобавитьРеквизитыЧерезТочкуКВыгрузке(Реквизиты);
	
	адаптер_НастройкиОбмена.ДобавитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		Реквизиты);
	
	ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства);
	ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства);
	
КонецПроцедуры

Процедура ЗаполнитьТекстыЗапросовУсловиями(ТекстЗапроса, ТекстЗапросаТаблицаКлючей, ПараметрыЗапроса, НастройкаВыгрузки, Объект, СтандартнаяОбработка) Экспорт
	
	ТекстПоиска = "МаркаНаименование КАК";
	ТекстЗамены = "бг_Марка.Наименование КАК";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстПоиска, ТекстЗамены);
	
	ТекстПоиска = "NULL КАК НомерСтроки";
	ТекстЗамены = "ВыгружаемыйОбъект.Заказы.НомерСтроки КАК НомерСтроки";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстПоиска, ТекстЗамены);	
			
	ТекстПоиска = "NULL КАК СуммаНакладной";
	ТекстЗамены =
	"ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ВыгружаемыйОбъект.Заказы.ДокументОтгрузки) = ТИП(Документ.РеализацияТоваровУслуг)
	|			ТОГДА ВЫРАЗИТЬ(ВыгружаемыйОбъект.Заказы.ДокументОтгрузки КАК Документ.РеализацияТоваровУслуг).СуммаДокумента
	|		КОГДА ТИПЗНАЧЕНИЯ(ВыгружаемыйОбъект.Заказы.ДокументОтгрузки) = ТИП(Документ.ПриобретениеТоваровУслуг)
	|			ТОГДА ВЫРАЗИТЬ(ВыгружаемыйОбъект.Заказы.ДокументОтгрузки КАК Документ.ПриобретениеТоваровУслуг).СуммаДокумента
	|		КОГДА ТИПЗНАЧЕНИЯ(ВыгружаемыйОбъект.Заказы.ДокументОтгрузки) = ТИП(Документ.ПередачаТоваровХранителю)
	|			ТОГДА ВЫРАЗИТЬ(ВыгружаемыйОбъект.Заказы.ДокументОтгрузки КАК Документ.ПередачаТоваровХранителю).СуммаДокумента
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаНакладной";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстПоиска, ТекстЗамены);
	
	ТекстПоиска = "NULL КАК Адрес";
	ТекстЗамены = "ВыгружаемыйОбъект.Заказы.ПунктНазначения.Адрес КАК Адрес";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстПоиска, ТекстЗамены);	
	
КонецПроцедуры

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта,
		СписокСвойств = Неопределено, ИсключаяСвойства = Неопределено, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;

	ЗаполнитьМаршрутныйЛист(ЗагружаемыйОбъект, СтруктураОбъекта);
КонецПроцедуры

Функция ПолучитьКлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения, ИсточникОбъект = Неопределено) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	КлючМаршрутизации = адаптер_ОбработчикиСобытийСтандартный.ПолучитьКлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения);
	
	ТипВнешнейСкладскойСистемыSolvo = Перечисления.бг_ТипыВнешнихСкладскихСистем.Solvo;
	
	Если ИсточникОбъект <> Неопределено Тогда
		ТипВнешнейСкладскойСистемыСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникОбъект.Склад, "бг_ТипВнешнейСкладскойСистемы");
		
		ВсеОрдераСозданы = Документы.битМаршрутныйЛист.ВсеОрдераПоЗаказамМаршрутногоЛистаСозданы(ИсточникОбъект.Ссылка);
		
		Если ТипВнешнейСкладскойСистемыСклада = ТипВнешнейСкладскойСистемыSolvo
			И ВсеОрдераСозданы Тогда
			КлючМаршрутизации = КлючМаршрутизации + ".WMS";
		КонецЕсли;
		
		ПрефиксОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсточникОбъект.Организация, "Префикс");
		Если ЗначениеЗаполнено(ПрефиксОрганизации) Тогда
			КлючМаршрутизации = СтрШаблон("%1.%2", КлючМаршрутизации, ПрефиксОрганизации);
		КонецЕсли;
	ИначеЕсли ДанныеСообщения.Свойство("Объект") И ОбщегоНазначения.СсылкаСуществует(ДанныеСообщения.Объект) Тогда
		ВсеОрдераСозданы = Документы.битМаршрутныйЛист.ВсеОрдераПоЗаказамМаршрутногоЛистаСозданы(ДанныеСообщения.Объект);
		
		ТипВнешнейСкладскойСистемыСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			ДанныеСообщения.Объект,
			"Склад.бг_ТипВнешнейСкладскойСистемы");
		
		Если ТипВнешнейСкладскойСистемыСклада = ТипВнешнейСкладскойСистемыSolvo
			И ВсеОрдераСозданы Тогда
			КлючМаршрутизации = КлючМаршрутизации + ".WMS";
		КонецЕсли;
		
		ПрефиксОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСообщения.Объект, "Организация.Префикс");
		Если ЗначениеЗаполнено(ПрефиксОрганизации) Тогда
			КлючМаршрутизации = СтрШаблон("%1.%2", КлючМаршрутизации, ПрефиксОрганизации);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КлючМаршрутизации;

КонецФункции

#КонецОбласти // Конец ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()

	ВыгружаемыеРеквизиты = Новый Массив;
	
	ВыгружаемыеРеквизиты.Добавить("ОтгрузкаИзERP");
	
	Возврат ВыгружаемыеРеквизиты;
	
КонецФункции

Процедура ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	// Реквизиты шапки
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ПлановаяДатаОтгрузки",
		ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ДатаИзмененияСтатусаРейса",
		ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
		
	// Реквизиты ТЧ "Заказы"
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"Заказы.НомерСтроки",
		ОбщегоНазначения.ОписаниеТипаЧисло(10));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"Заказы.СуммаНакладной",
		ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));

КонецПроцедуры

Процедура ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.ТранспортныеСредства,
		"МаркаНаименование",
		,
		Метаданные.Справочники.бг_МаркиТС.СтандартныеРеквизиты.Наименование.Тип);
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.ФизическиеЛица,
		"Наименование");
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.бг_Департаменты,
		"Наименование");
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.бг_ДоговорыВладенияТС,
		"Наименование");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.ЗаказКлиента,
		"бг_ЗаказРозничногоПокупателя", ,
		Новый ОписаниеТипов("ДокументСсылка.ЗаказКлиента"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.битПунктыНазначения,
		"Адрес");
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.битМаршрутныйЛист,
		"Номер");
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.битМаршрутныйЛист,
		"Дата");
	
КонецПроцедуры

Процедура ДобавитьРеквизитыЧерезТочкуКВыгрузке(Реквизиты)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Реквизиты.Добавить(
		адаптер_НастройкиОбмена.ОписаниеРеквизита(
			"ПунктРазгрузки",
			Новый ОписаниеТипов("СправочникСсылка.Контрагенты"),
			"Склад.бг_ПунктРазгрузки"));
		
	Реквизиты.Добавить(
		адаптер_НастройкиОбмена.ОписаниеРеквизита(
			"КодКатегорииСкладаSolvo",
			ОбщегоНазначения.ОписаниеТипаСтрока(2),
			"Склад.бг_КодКатегорииСкладаSolvo"));
		
	Реквизиты.Добавить(
		адаптер_НастройкиОбмена.ОписаниеРеквизита(
			"ОрганизацияСклада",
			Новый ОписаниеТипов("СправочникСсылка.Организации"),
			"Склад.бг_Организация"));

	Реквизиты.Добавить(
		адаптер_НастройкиОбмена.ОписаниеРеквизита(
			"Представление",
			ОбщегоНазначения.ОписаниеТипаСтрока(200),
			"Представление"));
						
КонецПроцедуры

Функция ПлановаяДатаОтгрузкиМаршрутногоЛиста(МаршрутныйЛист)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МИНИМУМ(ЗаказКлиента.ДатаОтгрузки) КАК ПлановаяДатаОтгрузки
		|ИЗ
		|	Документ.битМаршрутныйЛист.Заказы КАК битМаршрутныйЛистЗаказы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ПО битМаршрутныйЛистЗаказы.Заказ = ЗаказКлиента.Ссылка
		|ГДЕ
		|	битМаршрутныйЛистЗаказы.Ссылка = &МаршрутныйЛист";	
	Запрос.УстановитьПараметр("МаршрутныйЛист", МаршрутныйЛист);	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДатаОтгрузкиЗаказовКлиента = Дата(1, 1, 1);
	Если Не РезультатЗапроса.Пустой() Тогда 
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	    ВыборкаДетальныеЗаписи.Следующий();
		
		ДатаОтгрузкиЗаказовКлиента = ВыборкаДетальныеЗаписи.ПлановаяДатаОтгрузки;	
	КонецЕсли;
	
	Возврат ДатаОтгрузкиЗаказовКлиента;	
	
КонецФункции

Процедура ЗаполнитьМаршрутныйЛист(ЗагружаемыйОбъект, СтруктураОбъекта)
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");

	Если Не ЗагружаемыйОбъект.ЭтоНовый()
		И СокрЛП(ЗагружаемыйОбъект.НомерДокументаУПП) <> СокрЛП(СтруктураОбъекта.Номер) 
		И СтруктураОбъекта.Свойство("бг_ОбратнаяВыгрузка")
		И СтруктураОбъекта.бг_ОбратнаяВыгрузка = Истина Тогда				
		ЗагружаемыйОбъект.НомерДокументаУПП = СтруктураОбъекта.Номер; 
		
		// Если изменился только номер УПП, то запишем в режиме загрузки данных,
		// чтобы не перепроводить документ без необходимости.
		бг_ОбщегоНазначенияСервер.ЗаписатьЗагружаемыйОбъектВРежимеЗагрузкиДанных(ЗагружаемыйОбъект);
		
		Возврат; 
	ИначеЕсли СтруктураОбъекта.Свойство("бг_ОбратнаяВыгрузка")
			И СтруктураОбъекта.бг_ОбратнаяВыгрузка = Истина Тогда	
		ЗагружаемыйОбъект.ДополнительныеСвойства.Вставить("СтандартнаяЗаписьНеТребуется", Истина);
		Возврат;	
	КонецЕсли; 
	
	Если СтруктураОбъекта.Свойство("ВидДокумента")
		И СтруктураОбъекта.ВидДокумента = "Рейс" Тогда
		ВидДокумента  = Перечисления.бг_ВидыМаршрутныхЛистов.Рейс;
	Иначе
		ВидДокумента  = Перечисления.бг_ВидыМаршрутныхЛистов.МаршрутныйЛист;
	КонецЕсли;
	
	СтруктураОбъекта.Вставить("Проведен", Не СтруктураОбъекта.ПометкаУдаления);
	
	ПодготовитьРасходыКЗагрузке(СтруктураОбъекта);
	
	ИсключаемыеСвойства = "Номер";
	адаптер_ОбработчикиСобытийСтандартный.ЗаполнитьЗагружаемыйОбъект(
		ЗагружаемыйОбъект,
		СтруктураОбъекта,
		Неопределено,
		ИсключаемыеСвойства);
		
	ЗагружаемыйОбъект.ВидДокумента = ВидДокумента;
	ЗагружаемыйОбъект.Организация   = СтруктураОбъекта.Заказчик;
	ЗагружаемыйОбъект.ТипВладенияТС = ТипВладенияТС(СтруктураОбъекта);
	ЗагружаемыйОбъект.КлассГрузоподъемности = СтруктураОбъекта.ТоннажАМ;
	ЗагружаемыйОбъект.МаршрутУказанВручную = Не ПустаяСтрока(ЗагружаемыйОбъект.МаршрутДоставки);
	
	Если СтруктураОбъекта.Свойство("ОрганизаторПеревозки")
			И ЗначениеЗаполнено(СтруктураОбъекта.ОрганизаторПеревозки) Тогда
		ЗагружаемыйОбъект.Перевозчик = СтруктураОбъекта.ОрганизаторПеревозки;
		ЗагружаемыйОбъект.СубПодрядчик = СтруктураОбъекта.Перевозчик;
		ЗагружаемыйОбъект.ДоговорСубподряда = СтруктураОбъекта.ДоговорНаПеревозку;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗагружаемыйОбъект.Перевозчик) Тогда
		ЗагружаемыйОбъект.ПеревозчикПартнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗагружаемыйОбъект.Перевозчик, "Партнер");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗагружаемыйОбъект.СубПодрядчик) Тогда
		ЗагружаемыйОбъект.СубподрядчикПартнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗагружаемыйОбъект.СубПодрядчик, "Партнер");
	КонецЕсли;
	
	ЗагружаемыйОбъект.Заказы.Очистить();
	ЗаполнитьТабличнуюЧастьЗаказы(ЗагружаемыйОбъект, СтруктураОбъекта, "Заказы");
	ЗаполнитьТабличнуюЧастьЗаказы(ЗагружаемыйОбъект, СтруктураОбъекта, "ДокументыОтгрузки");
	
	Если ЗагружаемыйОбъект.ВидДокумента = Перечисления.бг_ВидыМаршрутныхЛистов.Рейс Тогда
		ЗагружаемыйОбъект.ДатаПрибытияФакт = СтруктураОбъекта.ДатаПрибытияАвтомобиляНаСклад;
		ЗаполнитьЗаказыДляДокументовОтгрузки(ЗагружаемыйОбъект.Заказы);
		ЗагружаемыйОбъект.ЗаказыОпределитьСуммыДокументов();
	КонецЕсли;
	
	ДанныеЗаполнения = ЗагружаемыйОбъект.РасширенныеДанныеЗаказов();
	ЗагружаемыйОбъект.ОпределитьВидПеревозки(ДанныеЗаполнения);
	
	ЗагружаемыйОбъект.Комментарий = СтрШаблон(
			"%1 // Загружено из ЛВЗ (%2 №%3 от %4)",
			СтруктураОбъекта.Комментарий,
			?(ЗагружаемыйОбъект.ВидДокумента = Перечисления.бг_ВидыМаршрутныхЛистов.МаршрутныйЛист, НСтр("ru='Маршрутный лист'"), НСтр("ru='Рейс'")),
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СтруктураОбъекта.Номер),
			СтруктураОбъекта.Дата);
КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧастьЗаказы(ЗагружаемыйОбъект, СтруктураОбъекта, ИмяТабличнойЧастиИсточник)
	Если Не СтруктураОбъекта.Свойство(ИмяТабличнойЧастиИсточник)
		Или СтруктураОбъекта[ИмяТабличнойЧастиИсточник] = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаЗаказ Из СтруктураОбъекта[ИмяТабличнойЧастиИсточник] Цикл
		НоваяСтрокаЗаказ = ЗагружаемыйОбъект.Заказы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаЗаказ, СтрокаЗаказ);
		
		Если ИмяТабличнойЧастиИсточник = "Заказы" Тогда
			НоваяСтрокаЗаказ.Заказ = СтрокаЗаказ.ЗаказПокупателя;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПодготовитьРасходыКЗагрузке(СтруктураОбъекта) Экспорт
	СоответствиеВидовРасходовСтатьям = РегистрыСведений.бг_СоответствиеВидовТранспортныхРасходовСтатьямРасходов.ПолучитьСоответствиеСтатей();
	
	СоответствиеВидовТранспортныхРасходов = Новый Соответствие;
	СоответствиеВидовТранспортныхРасходов.Вставить("Транспортные расходы возмещаемые", Перечисления.бг_ВидыТранспортныхРасходов.ТранспортныеРасходыВозмещаемые);
	СоответствиеВидовТранспортныхРасходов.Вставить("Транспортные расходы невозмещаемые", Перечисления.бг_ВидыТранспортныхРасходов.ТранспортныеРасходыНевозмещаемые);
	СоответствиеВидовТранспортныхРасходов.Вставить("Хранение/подключение возмещаемые", Перечисления.бг_ВидыТранспортныхРасходов.ХранениеПодключениеВозмещаемые);
	СоответствиеВидовТранспортныхРасходов.Вставить("Хранение/подключение невозмещаемые", Перечисления.бг_ВидыТранспортныхРасходов.ХранениеПодключениеНевозмещаемые);
	СоответствиеВидовТранспортныхРасходов.Вставить("Страхование возмещаемое", Перечисления.бг_ВидыТранспортныхРасходов.СтрахованиеВозмещаемое);
	СоответствиеВидовТранспортныхРасходов.Вставить("Страхование невозмещаемое", Перечисления.бг_ВидыТранспортныхРасходов.СтрахованиеНевозмещаемое);
	СоответствиеВидовТранспортныхРасходов.Вставить("Километраж", Перечисления.бг_ВидыТранспортныхРасходов.Километраж);
	СоответствиеВидовТранспортныхРасходов.Вставить("Чек и прочие доп. расходы", Перечисления.бг_ВидыТранспортныхРасходов.ЧекПрочиеДопРасходы);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой при погрузке возмещаемый", Перечисления.бг_ВидыТранспортныхРасходов.ПростойПриПогрузкеВозмещаемый);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой при погрузке возмещаемый (часы)", Перечисления.бг_ВидыТранспортныхРасходов.ПростойПриПогрузкеВозмещаемыйЧасы);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой при погрузке невозмещаемый", Перечисления.бг_ВидыТранспортныхРасходов.ПростойПриПогрузкеНевозмещаемый);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой при погрузке невозмещаемый (часы)", Перечисления.бг_ВидыТранспортныхРасходов.ПростойПриПогрузкеНевозмещаемыйЧасы);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой возмещаемый", Перечисления.бг_ВидыТранспортныхРасходов.ПростойВозмещаемый);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой возмещаемый (часы)", Перечисления.бг_ВидыТранспортныхРасходов.ПростойВозмещаемыйЧасы);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой невозмещаемый", Перечисления.бг_ВидыТранспортныхРасходов.ПростойНевозмещаемый);
	СоответствиеВидовТранспортныхРасходов.Вставить("Простой невозмещаемый (часы)", Перечисления.бг_ВидыТранспортныхРасходов.ПростойНевозмещаемыйЧасы);
	СоответствиеВидовТранспортныхРасходов.Вставить("Погрузочно-разгрузочные работы возмещаемые", Перечисления.бг_ВидыТранспортныхРасходов.ПРРВозмещаемые);
	СоответствиеВидовТранспортныхРасходов.Вставить("Погрузочно-разгрузочные работы невозмещаемые", Перечисления.бг_ВидыТранспортныхРасходов.ПРРНевозмещаемые);
	СоответствиеВидовТранспортныхРасходов.Вставить("Транспортные расходы при возврате продукции", Перечисления.бг_ВидыТранспортныхРасходов.ВозвратПродукции);
	СоответствиеВидовТранспортныхРасходов.Вставить("Транспортные расходы по доставке товаров от поставщиков",
																			Перечисления.бг_ВидыТранспортныхРасходов.ДоставкаТоваровОтПоставщиков);
	СоответствиеВидовТранспортныхРасходов.Вставить("Расходы на межскладское перемещение товара наемным транспортом (в рамках одного склада)",
																			Перечисления.бг_ВидыТранспортныхРасходов.МежскладскоеПеремещениеНаемнымТранспортом);
	СоответствиеВидовТранспортныхРасходов.Вставить("Транспортные расходы по доставке в места хранения", Перечисления.бг_ВидыТранспортныхРасходов.ДоставкаВМестаХранения);
	
	ОтборСтатьиРасходов = Новый Структура("ВидТранспортныхРасходов");
	
	Если СтруктураОбъекта.Свойство("Расходы") И ТипЗнч(СтруктураОбъекта.Расходы) = Тип("Массив") Тогда
		Для Каждого СтрокаРасходы Из СтруктураОбъекта.Расходы Цикл  
			Если СтрокаРасходы.Свойство("СтатьяРасходов")
				И СтрокаРасходы.СтатьяРасходов.Свойство("Наименование")
				И Не ПустаяСтрока(СтрокаРасходы.СтатьяРасходов.Наименование) Тогда
				
				СтрокаРасходы.Вставить("ВидТранспортныхРасходов", СоответствиеВидовТранспортныхРасходов.Получить(СтрокаРасходы.СтатьяРасходов.Наименование));
				
				ОтборСтатьиРасходов.ВидТранспортныхРасходов = СтрокаРасходы.ВидТранспортныхРасходов;
				СтрокиСоответствиеСтатьям = СоответствиеВидовРасходовСтатьям.НайтиСтроки(ОтборСтатьиРасходов);
				СтрокаРасходы.СтатьяРасходов = ?(СтрокиСоответствиеСтатьям.Количество() = 0, СтрокаРасходы.СтатьяРасходов, СтрокиСоответствиеСтатьям[0].СтатьяРасходов);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ТипВладенияТС(СтруктураОбъекта)
	Если Не СтруктураОбъекта.Свойство("ТипВладенияАМ") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТипыВладенияТС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.бг_ТипыВладенияТС КАК ТипыВладенияТС
	|ГДЕ
	|	ТипыВладенияТС.Код = &Код
	|	И НЕ ТипыВладенияТС.ПометкаУдаления";
	Запрос.УстановитьПараметр("Код", СтруктураОбъекта.ТипВладенияАМ);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Процедура ЗаполнитьЗаказыДляДокументовОтгрузки(Заказы)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК ДокументОтгрузки,
	|	РеализацияТоваровУслуг.ЗаказКлиента КАК Заказ
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В(&ДокументыОтгрузки)";
	Запрос.УстановитьПараметр("ДокументыОтгрузки", Заказы.ВыгрузитьКолонку("ДокументОтгрузки"));
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОтборСтроки = Новый Структура("ДокументОтгрузки", Выборка.ДокументОтгрузки);
		СтрокиЗаказы = Заказы.НайтиСтроки(ОтборСтроки);
		Для Каждого СтрокаЗаказ Из СтрокиЗаказы Цикл
			СтрокаЗаказ.Заказ = Выборка.Заказ;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти // Конец СлужебныеПроцедурыИФункции
