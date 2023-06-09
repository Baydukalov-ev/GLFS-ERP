#Область ПрограммныйИнтерфейс

Процедура ДобавитьПоляНаФормуДокумента(Форма) Экспорт
	
	// MobileSmarts
	ДобавитьПолеРазрешитьПараллельнуюСборку(Форма);
	ДобавитьПолеКонтролироватьСерии(Форма);
	ДобавитьПолеОбязательнаяАгрегация(Форма);
	ДобавитьПолеИсполнитель(Форма);
	ДобавитьПолеТипПриемки(Форма);
	
	// Solvo
	ДобавитьПолеПриоритет(Форма);	

КонецПроцедуры

Функция СтраницаWMS(Форма) Экспорт

	СтраницаWMS = Форма.Элементы.Найти("бг_ГруппаWMS");
	
	Если СтраницаWMS = Неопределено Тогда
		
		СтраницаWMS = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
			Форма, 
			"бг_ГруппаWMS", 
			ГруппаСтраницыФормы(Форма),
			ВидГруппыФормы.Страница);
			
		СтраницаWMS.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		СтраницаWMS.Заголовок = НСтр("ru = 'WMS'");
		
	КонецЕсли;
	
	Возврат СтраницаWMS;

КонецФункции

Функция ГруппаMobileSmarts(Форма) Экспорт

	ГруппаMobileSmarts = Форма.Элементы.Найти("бг_ГруппаMobileSmarts");
	
	Если ГруппаMobileSmarts = Неопределено Тогда
		
		ГруппаMobileSmarts = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
			Форма, 
			"бг_ГруппаMobileSmarts",
			СтраницаWMS(Форма),
			ВидГруппыФормы.ОбычнаяГруппа);
			
		ГруппаMobileSmarts.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ГруппаMobileSmarts.Заголовок = НСтр("ru = 'Mobile Smarts'");
		
	КонецЕсли;
	
	Возврат ГруппаMobileSmarts;

КонецФункции

Функция ГруппаSolvo(Форма) Экспорт

	ГруппаSolvo = Форма.Элементы.Найти("бг_ГруппаSolvo");
	
	Если ГруппаSolvo = Неопределено Тогда
		
		ГруппаSolvo = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
			Форма, 
			"бг_ГруппаSolvo",
			СтраницаWMS(Форма),
			ВидГруппыФормы.ОбычнаяГруппа);
			
		ГруппаSolvo.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ГруппаSolvo.Заголовок = НСтр("ru = 'Solvo'");
		
	КонецЕсли;
	
	Возврат ГруппаSolvo;

КонецФункции

Процедура ОбработатьВходящиеТовары(Товары) Экспорт

	ТаблицаТовары = Товары.Выгрузить();
	ТаблицаТовары.Свернуть("Номенклатура, Серия", "Количество");
	Товары.Загрузить(ТаблицаТовары);
	
	ПараметрыПоиска = Новый Структура("Количество", 0);
	НайденныеСтроки = Товары.НайтиСтроки(ПараметрыПоиска);
	
	Для каждого СтрокаТовары Из НайденныеСтроки Цикл
		Товары.Удалить(СтрокаТовары);
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьСтатусДокумента(Ссылка, НовыйСтатус, ДополнительныеСвойства, Отказ) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийСтатус = РегистрыСведений.бг_ДокументыИнтеграцииСоСкладскимиСистемами.ТекущийСтатус(Ссылка);
	Если ТекущийСтатус = НовыйСтатус Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.бг_ДокументыИнтеграцииСоСкладскимиСистемами.ОбновитьСтатусДокумента(
		Ссылка,
		ТекущаяДатаСеанса(),
		НовыйСтатус,
		ВремяОбработки(ДополнительныеСвойства));

КонецПроцедуры

Функция ВремяОбработки(ДополнительныеСвойства) Экспорт

	ВремяОбработки = 0;
	Если ДополнительныеСвойства.Свойство("ДатаНачалаОбработки")
		И ДополнительныеСвойства.Свойство("ДатаОкончанияОбработки") Тогда
		
		ВремяОбработки = ДополнительныеСвойства.ДатаОкончанияОбработки - ДополнительныеСвойства.ДатаНачалаОбработки;
	КонецЕсли;
	
	Возврат ВремяОбработки;

КонецФункции	

Процедура СообщитьПользователю(ТекстОшибки, Ссылка, Отказ) Экспорт

	ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка,,, Отказ);

КонецПроцедуры

#Область РасчетПоказателейРаботыОператоровWMS

Функция НовыйДанныеДляРасчетаПоказателейРаботыОператоровWMS() Экспорт
	
	МетаданныеТоваров = Метаданные.Документы.ЗаказКлиента.ТабличныеЧасти.Товары.Реквизиты;
	
	ДанныеДляРасчета = Новый Структура;
	
	ДанныеДляРасчета.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	ДанныеДляРасчета.Вставить("ОрганизацияЕГАИС", Справочники.КлассификаторОрганизацийЕГАИС.ПустаяСсылка());
	ДанныеДляРасчета.Вставить("СтатусыМарок", Неопределено);
	ДанныеДляРасчета.Вставить("ИгнорироватьТовары", Ложь);
	
	// ДанныеШапкиДокумента
	ДанныеШапкиДокумента = Новый Структура;
	ДанныеШапкиДокумента.Вставить("Документ", Неопределено);
	ДанныеШапкиДокумента.Вставить("Проведен", Ложь);
	ДанныеШапкиДокумента.Вставить("Дата", Дата(1, 1, 1));
	ДанныеШапкиДокумента.Вставить("ВремяВыполнения", 0);
	ДанныеШапкиДокумента.Вставить("ОператорТСД", Справочники.Пользователи.ПустаяСсылка());
	ДанныеШапкиДокумента.Вставить("ПунктРазгрузки", Справочники.Контрагенты.ПустаяСсылка());
	ДанныеШапкиДокумента.Вставить("Распоряжение", Неопределено);
	ДанныеШапкиДокумента.Вставить("КаналПродаж", Справочники.битКаналыПродаж.ПустаяСсылка());
	ДанныеШапкиДокумента.Вставить("Территория", Справочники.битТерриторииПунктовНазначения.ПустаяСсылка());
	
	ДанныеДляРасчета.Вставить("ДанныеШапкиДокумента", ДанныеШапкиДокумента);
	
	// ТоварыРаспоряжения
	ТоварыРаспоряжения = Новый ТаблицаЗначений;
	ТоварыРаспоряжения.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТоварыРаспоряжения.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ТоварыРаспоряжения.Колонки.Добавить("Количество", МетаданныеТоваров.Количество.Тип);
	ТоварыРаспоряжения.Колонки.Добавить("Сумма", МетаданныеТоваров.Сумма.Тип);
	
	ДанныеДляРасчета.Вставить("ТоварыРаспоряжения", ТоварыРаспоряжения);
	
	// ТоварыДокумента
	ТоварыДокумента = Новый ТаблицаЗначений;
	ТоварыДокумента.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТоварыДокумента.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ТоварыДокумента.Колонки.Добавить("Количество", МетаданныеТоваров.Количество.Тип);
	
	ДанныеДляРасчета.Вставить("ТоварыДокумента", ТоварыДокумента);
	
	// ШтрихкодыДокумента
	ШтрихкодыДокумента = Новый ТаблицаЗначений;
	ШтрихкодыДокумента.Колонки.Добавить(
		"Штрихкод",
		ОбщегоНазначения.ОписаниеТипаСтрока(
			бг_МаркируемаяПродукция.ДлиныШтрихкодовМарок().ПолнаяМарка));
	
	ДанныеДляРасчета.Вставить("ШтрихкодыДокумента", ШтрихкодыДокумента);
	
	Возврат ДанныеДляРасчета;
	
КонецФункции

Процедура СформироватьДвиженияПоказателейРаботыОператоровWMS(ДанныеДляРасчета) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоказателиРаботыОператоровWMSПоТоварам = ПоказателиРаботыОператоровWMSПоТоварам(ДанныеДляРасчета);
	
	НаборЗаписей = РегистрыНакопления.бг_ПоказателиРаботыОператоровWMS.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Значение = ДанныеДляРасчета.ДанныеШапкиДокумента.Документ;
	НаборЗаписей.Отбор.Регистратор.Использование = Истина;
	
	Если Не ДанныеДляРасчета.ДанныеШапкиДокумента.Проведен Тогда
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
	
	Запись = НаборЗаписей.Добавить();
	
	Запись.Регистратор = ДанныеДляРасчета.ДанныеШапкиДокумента.Документ;
	Запись.Период = ДанныеДляРасчета.ДанныеШапкиДокумента.Дата;
	
	// Измерения
	Запись.Оператор = ДанныеДляРасчета.ДанныеШапкиДокумента.ОператорТСД;
	Запись.Организация = ДанныеДляРасчета.Организация;
	Запись.ПунктРазгрузки = ДанныеДляРасчета.ДанныеШапкиДокумента.ПунктРазгрузки;
	
	// Ресурсы
	Запись.ВремяВыполнения = ДанныеДляРасчета.ДанныеШапкиДокумента.ВремяВыполнения;
	Запись.КоличествоПозицийОтсканировано = ДанныеДляРасчета.ТоварыДокумента.Количество();
	Запись.КоличествоТоваровРаспоряжение = ДанныеДляРасчета.ТоварыРаспоряжения.Итог("Количество");
	Запись.СуммаТоваровРаспоряжение = ДанныеДляРасчета.ТоварыРаспоряжения.Итог("Сумма");
	
	ЗаполнитьЗначенияСвойств(Запись, ПоказателиРаботыОператоровWMSПоТоварам);
	
	// Реквизиты
	Запись.Распоряжение = ДанныеДляРасчета.ДанныеШапкиДокумента.Распоряжение;
	Запись.ДатаПолученияОтветаОтТСД = ДанныеДляРасчета.ДанныеШапкиДокумента.Дата;
	Запись.ДатаВыгрузкиРаспоряженияТСД = ДанныеДляРасчета.ДанныеШапкиДокумента.Дата
		- ДанныеДляРасчета.ДанныеШапкиДокумента.ВремяВыполнения;
	Запись.КаналПродаж = ДанныеДляРасчета.ДанныеШапкиДокумента.КаналПродаж;
	Запись.Территория = ДанныеДляРасчета.ДанныеШапкиДокумента.Территория;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти // Конец РасчетПоказателейРаботыОператоровWMS

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСФормами

#Область MobileSmarts

Процедура ДобавитьПолеРазрешитьПараллельнуюСборку(Форма)
	
	Если Не ВыводитьПолеРазрешитьПараллельнуюСборку(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	бг_РазрешитьПараллельнуюСборку = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		Форма,
		"бг_РазрешитьПараллельнуюСборку",
		ГруппаMobileSmarts(Форма),
		"Объект.бг_РазрешитьПараллельнуюСборку",
		, // ТипЭлемента
		, // Элемент (предшествующий)
		"ПолеФлажка");
		
КонецПроцедуры

Функция ВыводитьПолеРазрешитьПараллельнуюСборку(Форма)

	ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
	
	Если ТипДокумента = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		
		Возврат Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию;
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриходныйОрдерНаТовары")
		Или ТипДокумента = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		
		Возврат Истина;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПолеКонтролироватьСерии(Форма)
	
	Если Не ВыводитьПолеКонтролироватьСерии(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	бг_КонтролироватьСерии = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		Форма,
		"бг_КонтролироватьСерии",
		ГруппаMobileSmarts(Форма),
		"Объект.бг_КонтролироватьСерии",
		, // ТипЭлемента
		, // Элемент (предшествующий)
		"ПолеФлажка");
		
КонецПроцедуры

Функция ВыводитьПолеКонтролироватьСерии(Форма)

	ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
	
	Если ТипДокумента = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПолеОбязательнаяАгрегация(Форма)
	
	Если Не ВыводитьПолеОбязательнаяАгрегация(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	бг_ОбязательнаяАгрегация = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		Форма,
		"бг_ОбязательнаяАгрегация",
		ГруппаMobileSmarts(Форма),
		"Объект.бг_ОбязательнаяАгрегация",
		, // ТипЭлемента
		, // Элемент (предшествующий)
		"ПолеФлажка");
		
КонецПроцедуры

Функция ВыводитьПолеОбязательнаяАгрегация(Форма)

	ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
	
	Если ТипДокумента = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПолеИсполнитель(Форма)
	
	Если Не ВыводитьПолеИсполнитель(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	бг_Исполнитель = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		Форма,
		"бг_Исполнитель",
		ГруппаMobileSmarts(Форма),
		"Объект.бг_Исполнитель",
		, // ТипЭлемента
		, // Элемент (предшествующий)
		"ПолеВвода");
		
КонецПроцедуры

Функция ВыводитьПолеИсполнитель(Форма)

	ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
	
	Если ТипДокумента = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		
		Возврат Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию;
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриходныйОрдерНаТовары")
		Или ТипДокумента = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		
		Возврат Истина;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПолеТипПриемки(Форма) Экспорт

	Если Не ВыводитьПолеТипПриемки(Форма) Тогда
		Возврат;
	КонецЕсли;	
	
	бг_ТипПриемки = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		Форма,
		"бг_ТипПриемки",
		ГруппаMobileSmarts(Форма),
		"Объект.бг_ТипПриемки",
		, // ТипЭлемента
		, // Элемент (предшествующий)
		"ПолеВвода");
	бг_ТипПриемки.АвтоМаксимальнаяШирина = Ложь;
	бг_ТипПриемки.МаксимальнаяШирина = 28;
		
КонецПроцедуры

Функция ВыводитьПолеТипПриемки(Форма)

	ТипОбъекта = ТипЗнч(Форма.Объект.Ссылка);
	
	Если ТипОбъекта = Тип("ДокументСсылка.ПриходныйОрдерНаТовары") Тогда
		Возврат Истина;	
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Solvo

Процедура ДобавитьПолеПриоритет(Форма)
	
	Если Не ВыводитьПолеПриоритет(Форма) Тогда
		Возврат;
	КонецЕсли;	
	
	бг_Приоритет = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		Форма,
		"бг_Приоритет",
		ГруппаSolvo(Форма),
		"Объект.бг_Приоритет",
		, // ТипЭлемента
		, // Элемент (предшествующий)
		"ПолеВвода");
	бг_Приоритет.АвтоМаксимальнаяШирина = Ложь;
	бг_Приоритет.МаксимальнаяШирина = 28;
		
КонецПроцедуры

Функция ВыводитьПолеПриоритет(Форма)

	ТипДокумента = ТипЗнч(Форма.Объект.Ссылка);
	
	Если ТипДокумента = Тип("ДокументСсылка.ПриходныйОрдерНаТовары") Тогда
		Возврат Истина;	
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ГруппаСтраницыФормы(Форма)
	
	ГруппаСтраницы = Неопределено;
	Если Форма.Элементы.Найти("ГруппаСтраницы") <> Неопределено Тогда
		ГруппаСтраницы = Форма.Элементы.ГруппаСтраницы;
	ИначеЕсли Форма.Элементы.Найти("СтраницыФормы") <> Неопределено Тогда
		ГруппаСтраницы = Форма.Элементы.СтраницыФормы;
	КонецЕсли;
	
	Возврат ГруппаСтраницы;
	
КонецФункции

#Область РасчетПоказателейРаботыОператоровWMS

// Рассчитывает и возвращает количественные показатели отсканированных товаров и штрихкодов, необходимые
// для формирования движений по регистру бг_ПоказателиРаботыОператоровWMS.
//
// Параметры:
//  ДанныеДляРасчета - Структура.
//
// Возвращаемое значение:
//  Структура
//
Функция ПоказателиРаботыОператоровWMSПоТоварам(ДанныеДляРасчета) Экспорт
	
	Показатели = НовыйПоказателиРаботыОператоровWMS();
	
	Штрихкоды = ДанныеДляРасчета.ШтрихкодыДокумента.ВыгрузитьКолонку("Штрихкод");
	
	ДанныеМарокПоШтрихкодам = бг_МаркируемаяПродукция.ДанныеМарокПоШтрихкодам(
		Штрихкоды,
		ДанныеДляРасчета.ОрганизацияЕГАИС,
		ДанныеДляРасчета.СтатусыМарок,
		ДанныеДляРасчета.ДанныеШапкиДокумента.Дата);
		
	ШтрихкодыПоТипамУпаковок = бг_МаркируемаяПродукция.ШтрихкодыПоТипамУпаковок(Штрихкоды);
	
	ШтрихкодыКоробокПаллет = ШтрихкодыКоробокПаллет(ШтрихкодыПоТипамУпаковок);
	
	СтруктураКоробокПаллет = бг_МаркируемаяПродукция.ДанныеСоставаУпаковокСрезПоследних(
		ШтрихкодыКоробокПаллет,
		ДанныеДляРасчета.ДанныеШапкиДокумента.Дата);
		
	ДанныеОтсканированныхТоваров = ДанныеОтсканированныхТоваров(ДанныеДляРасчета.ТоварыДокумента);
	
	ДанныеОтсканированныхШтрихкодов = ДанныеОтсканированныхШтрихкодов(
		ДанныеДляРасчета,
		ШтрихкодыПоТипамУпаковок,
		ДанныеМарокПоШтрихкодам,
		ДанныеОтсканированныхТоваров,
		СтруктураКоробокПаллет);
		
	Показатели.КоличествоТоваровОтсканировано = ДанныеОтсканированныхТоваров.Итог("Количество");
	Показатели.ОбъемДАЛОтсканировано = ДанныеОтсканированныхТоваров.Итог("ОбъемДАЛ");
	Показатели.ОбъемДАЛСпиртОтсканировано = ДанныеОтсканированныхТоваров.Итог("ОбъемДАЛСпирт");
	Показатели.ОбъемДАЛМарокОтсканировано = ДанныеОтсканированныхШтрихкодов.Марки.Итог("ОбъемДАЛ");
	Показатели.ОбъемДАЛКоробокОтсканировано = ДанныеОтсканированныхШтрихкодов.Коробки.Итог("ОбъемДАЛ");
	Показатели.ОбъемДАЛПаллетОтсканировано = ДанныеОтсканированныхШтрихкодов.Паллеты.Итог("ОбъемДАЛ");
	Показатели.КоличествоМарокОтсканировано = ШтрихкодыПоТипамУпаковок.Марки.Количество();
	Показатели.КоличествоКоробокОтсканировано = ШтрихкодыПоТипамУпаковок.Коробки.Количество();
	Показатели.КоличествоПаллетОтсканировано = ШтрихкодыПоТипамУпаковок.Паллеты.Количество();
	
	Возврат Показатели;
	
КонецФункции

Функция НовыйПоказателиРаботыОператоровWMS()
	
	ПоказателиРаботыОператоровWMS = Новый Структура;
	
	ПоказателиРаботыОператоровWMS.Вставить("КоличествоТоваровОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("ОбъемДАЛОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("ОбъемДАЛСпиртОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("ОбъемДАЛМарокОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("ОбъемДАЛКоробокОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("ОбъемДАЛПаллетОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("КоличествоМарокОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("КоличествоКоробокОтсканировано", 0);
	ПоказателиРаботыОператоровWMS.Вставить("КоличествоПаллетОтсканировано", 0);
	
	Возврат ПоказателиРаботыОператоровWMS;
	
КонецФункции

Функция ШтрихкодыКоробокПаллет(ШтрихкодыПоТипамУпаковок)
	
	ШтрихкодыКоробокПаллет = Новый Массив;
	
	Для каждого Штрихкод Из ШтрихкодыПоТипамУпаковок.Коробки Цикл
		ШтрихкодыКоробокПаллет.Добавить(Штрихкод);
	КонецЦикла;
	
	Для каждого Штрихкод Из ШтрихкодыПоТипамУпаковок.Паллеты Цикл
		ШтрихкодыКоробокПаллет.Добавить(Штрихкод);
	КонецЦикла;
	
	Возврат ШтрихкодыКоробокПаллет;
	
КонецФункции

Функция ДанныеОтсканированныхТоваров(ТоварыДокумента)
	
	ОтсканированныеТовары = ТоварыДокумента.Скопировать();
	ОтсканированныеТовары.Свернуть("Номенклатура, Серия", "Количество");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтсканированныеТовары.Номенклатура КАК Номенклатура,
	|	ОтсканированныеТовары.Серия КАК Серия,
	|	ОтсканированныеТовары.Количество КАК Количество
	|ПОМЕСТИТЬ ОтсканированныеТовары
	|ИЗ
	|	&ОтсканированныеТовары КАК ОтсканированныеТовары
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	ОтсканированныеТовары.Серия КАК Серия,
	|	СправочникНоменклатура.ОбъемДАЛ КАК НоменклатураОбъемДАЛ,
	|	СправочникНоменклатура.Крепость КАК НоменклатураКрепость,
	|	СУММА(ОтсканированныеТовары.Количество) КАК Количество,
	|	СУММА(ОтсканированныеТовары.Количество * СправочникНоменклатура.ОбъемДАЛ) КАК ОбъемДАЛ,
	|	СУММА(ОтсканированныеТовары.Количество * СправочникНоменклатура.ОбъемДАЛ * СправочникНоменклатура.Крепость / 100) КАК ОбъемДАЛСпирт
	|ИЗ
	|	ОтсканированныеТовары КАК ОтсканированныеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ОтсканированныеТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СправочникНоменклатура.Ссылка,
	|	СправочникНоменклатура.ОбъемДАЛ,
	|	СправочникНоменклатура.Крепость,
	|	ОтсканированныеТовары.Серия";
	
	Запрос.УстановитьПараметр("ОтсканированныеТовары", ОтсканированныеТовары);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ДанныеОтсканированныхШтрихкодов(ДанныеДляРасчета, ШтрихкодыПоТипамУпаковок, ДанныеМарок, ДанныеТоваров,
	СтруктураКоробокПаллет)
	
	ДанныеМарок.Индексы.Добавить("Штрихкод");
	ДанныеМарок.Индексы.Добавить("ШтрихкодРодитель");
	СтруктураКоробокПаллет.Индексы.Добавить("ШтрихкодРодитель");
	ДанныеТоваров.Индексы.Добавить("Серия");
	
	ДанныеОтсканированныхШтрихкодов = НовыйДанныеОтсканированныхШтрихкодов();
	
	// 1. Для коробок необходимо рассчитать количество марок в каждой коробке - в ДанныеМарок содержатся
	//  все разузлованные штрихкоды до марок с указанием родителей.
	Для каждого Штрихкод Из ШтрихкодыПоТипамУпаковок.Коробки Цикл
		
		НоваяСтрокаКоробки = ДанныеОтсканированныхШтрихкодов.Коробки.Добавить();
		НоваяСтрокаКоробки.Штрихкод = Штрихкод;
		
		ПараметрыПоискаМарок = Новый Структура("ШтрихкодРодитель", Штрихкод);
		НайденныеСтрокиМарки = ДанныеМарок.НайтиСтроки(ПараметрыПоискаМарок);
		
		НоваяСтрокаКоробки.КоличествоМарок = НайденныеСтрокиМарки.Количество();
		
		//  2. Для каждой отсканированной коробки определяем объем ДАЛ, эти данные есть только в номенклатуре, но явной
		//   связи коробка+номенклатура нет, поэтому определяем номенклатуру для коробки косвенно через состав марок,
		//   хранящихся в коробке. Предполагаем, что в одной коробке не может быть разной номенклатуры.
		Если НоваяСтрокаКоробки.КоличествоМарок > 0 Тогда
			
			ДанныеМарки = НайденныеСтрокиМарки[0];
			
			ПараметрыПоискаТовара = Новый Структура("Серия", ДанныеМарки.Серия);
			НайденныеСтрокиТовара = ДанныеТоваров.НайтиСтроки(ПараметрыПоискаТовара);
			
			Если НайденныеСтрокиТовара.Количество() > 0 Тогда
				ДанныеТовара = НайденныеСтрокиТовара[0];
				НоваяСтрокаКоробки.ОбъемДАЛ = ДанныеТовара.НоменклатураОбъемДАЛ * НоваяСтрокаКоробки.КоличествоМарок;
			Иначе
				Если Не ДанныеДляРасчета.ИгнорироватьТовары Тогда
					СообщитьОшибкуНетДанныхТовара(ДанныеМарки.Серия);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// 3. Для паллет необходимо рассчитать количество марок в каждой паллете - суммированием марок
	//  в каждой коробке, содержащейся в этой паллете.
	Для каждого Штрихкод Из ШтрихкодыПоТипамУпаковок.Паллеты Цикл
		
		НоваяСтрокаПаллеты = ДанныеОтсканированныхШтрихкодов.Паллеты.Добавить();
		НоваяСтрокаПаллеты.Штрихкод = Штрихкод;
		
		ПараметрыПоискаКоробок = Новый Структура("ШтрихкодРодитель", Штрихкод);
		НайденныеСтрокиКоробки = СтруктураКоробокПаллет.НайтиСтроки(ПараметрыПоискаКоробок);
		
		ДанныеМарки = Неопределено;
		
		Для каждого СтрокаКоробки Из НайденныеСтрокиКоробки Цикл
			
			ПараметрыПоискаМарокВКоробке = Новый Структура("ШтрихкодРодитель", СтрокаКоробки.Штрихкод);
			НайденныеСтрокиМаркиВКоробке = ДанныеМарок.НайтиСтроки(ПараметрыПоискаМарокВКоробке);
			
			КоличествоМарокВКоробке = НайденныеСтрокиМаркиВКоробке.Количество();
			
			НоваяСтрокаПаллеты.КоличествоМарок = НоваяСтрокаПаллеты.КоличествоМарок + КоличествоМарокВКоробке;
			
			Если КоличествоМарокВКоробке > 0 И ДанныеМарки = Неопределено Тогда
				ДанныеМарки = НайденныеСтрокиМаркиВКоробке[0];
			КонецЕсли;
		КонецЦикла;
		
		//  4. Для каждой отсканированной паллеты определяем объем ДАЛ, эти данные есть только в номенклатуре, но явной
		//   связи паллета+номенклатура нет, поэтому определяем номенклатуру для паллеты косвенно через состав коробок,
		//   хранящихся в паллете, и состав марок, хранящихся в коробке. Предполагаем, что в одной коробке не может
		//   быть разной номенклатуры.
		Если НоваяСтрокаПаллеты.КоличествоМарок > 0 И ДанныеМарки <> Неопределено Тогда
			
			ДанныеМарки = НайденныеСтрокиМаркиВКоробке[0];
			
			ПараметрыПоискаТовара = Новый Структура("Серия", ДанныеМарки.Серия);
			НайденныеСтрокиТовара = ДанныеТоваров.НайтиСтроки(ПараметрыПоискаТовара);
			
			Если НайденныеСтрокиТовара.Количество() > 0 Тогда
				ДанныеТовара = НайденныеСтрокиТовара[0];
				НоваяСтрокаПаллеты.ОбъемДАЛ = ДанныеТовара.НоменклатураОбъемДАЛ * НоваяСтрокаПаллеты.КоличествоМарок;
			Иначе
				Если Не ДанныеДляРасчета.ИгнорироватьТовары Тогда
					СообщитьОшибкуНетДанныхТовара(ДанныеМарки.Серия);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ШтрихкодМарки Из ШтрихкодыПоТипамУпаковок.Марки Цикл
		
		НоваяСтрокаМарки = ДанныеОтсканированныхШтрихкодов.Марки.Добавить();
		НоваяСтрокаМарки.Штрихкод = ШтрихкодМарки;
		НоваяСтрокаМарки.КоличествоМарок = 1;
		
		//  5. Для каждой отсканированной марки определяем объем ДАЛ, эти данные есть только в номенклатуре, поэтому
		//   по каждой отсканированной марке ищем текущие данные этой марки на дату документа (таблица ДанныеМарок),
		//   затем, зная серию, ищем данные товара (таблица ДанныеТоваров), в числе которых есть объем ДАЛ.
		ПараметрыПоискаМарки = Новый Структура("Штрихкод", ШтрихкодМарки);
		НайденныеСтрокиДанныеМарки = ДанныеМарок.НайтиСтроки(ПараметрыПоискаМарки);
		Если НайденныеСтрокиДанныеМарки.Количество() = 0 Тогда
			Если ДанныеДляРасчета.ИгнорироватьТовары Тогда
				Продолжить;
			Иначе
				СообщитьОшибкуНетДанныхМарки(ШтрихкодМарки);
			КонецЕсли;
		КонецЕсли;
		
		ДанныеМарки = НайденныеСтрокиДанныеМарки[0];
		
		ПараметрыПоискаТовара = Новый Структура("Серия", ДанныеМарки.Серия);
		НайденныеСтрокиТовара = ДанныеТоваров.НайтиСтроки(ПараметрыПоискаТовара);
		Если НайденныеСтрокиТовара.Количество() = 0 Тогда
			Если ДанныеДляРасчета.ИгнорироватьТовары Тогда
				Продолжить;
			Иначе
				СообщитьОшибкуНетДанныхТовара(ДанныеМарки.Серия);
			КонецЕсли;
		КонецЕсли;
		
		Если НайденныеСтрокиТовара.Количество() > 0 Тогда
			
			ДанныеТовара = НайденныеСтрокиТовара[0];
			
			НоваяСтрокаМарки.ОбъемДАЛ = ДанныеТовара.НоменклатураОбъемДАЛ;
			
		Иначе
			Если Не ДанныеДляРасчета.ИгнорироватьТовары Тогда
				СообщитьОшибкуНетДанныхТовара(ДанныеМарки.Серия);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеОтсканированныхШтрихкодов;
	
КонецФункции

Процедура СообщитьОшибкуНетДанныхМарки(ШтрихкодМарки)
	
	ВызватьИсключение СтрШаблон(
		НСтр("ru='Не удалось найти данные штрихкода %1 при расчете показателей работы операторов ТСД'"),
		ШтрихкодМарки);
	
КонецПроцедуры

Процедура СообщитьОшибкуНетДанныхТовара(Серия)
	
	ВызватьИсключение СтрШаблон(
		НСтр("ru='Не удалось найти данные серии %1 при расчете показателей работы операторов ТСД'"),
		Серия);
	
КонецПроцедуры

Функция НовыйДанныеОтсканированныхШтрихкодов()
	
	ДанныеОтсканированныхШтрихкодов = Новый Структура;
	
	ДлиныШтрихкодовМарок = бг_МаркируемаяПродукция.ДлиныШтрихкодовМарок();
	ТипОбъемаДАЛ = Метаданные.Справочники.Номенклатура.Реквизиты.ОбъемДАЛ.Тип;
	
	Марки = Новый ТаблицаЗначений;
	Марки.Колонки.Добавить("Штрихкод", ОбщегоНазначения.ОписаниеТипаСтрока(ДлиныШтрихкодовМарок.ПолнаяМарка));
	Марки.Колонки.Добавить("ОбъемДАЛ", ТипОбъемаДАЛ);
	Марки.Колонки.Добавить("КоличествоМарок", ОбщегоНазначения.ОписаниеТипаЧисло(10, 0, ДопустимыйЗнак.Неотрицательный));
	
	Коробки = Новый ТаблицаЗначений;
	Коробки.Колонки.Добавить("Штрихкод", ОбщегоНазначения.ОписаниеТипаСтрока(ДлиныШтрихкодовМарок.Упаковка));
	Коробки.Колонки.Добавить("ОбъемДАЛ", ТипОбъемаДАЛ);
	Коробки.Колонки.Добавить("КоличествоМарок", ОбщегоНазначения.ОписаниеТипаЧисло(10, 0, ДопустимыйЗнак.Неотрицательный));
	
	Паллеты = Новый ТаблицаЗначений;
	Паллеты.Колонки.Добавить("Штрихкод", ОбщегоНазначения.ОписаниеТипаСтрока(ДлиныШтрихкодовМарок.Упаковка));
	Паллеты.Колонки.Добавить("ОбъемДАЛ", ТипОбъемаДАЛ);
	Паллеты.Колонки.Добавить("КоличествоМарок", ОбщегоНазначения.ОписаниеТипаЧисло(10, 0, ДопустимыйЗнак.Неотрицательный));
	
	ДанныеОтсканированныхШтрихкодов.Вставить("Марки", Марки);
	ДанныеОтсканированныхШтрихкодов.Вставить("Коробки", Коробки);
	ДанныеОтсканированныхШтрихкодов.Вставить("Паллеты", Паллеты);
	
	Возврат ДанныеОтсканированныхШтрихкодов;
	
КонецФункции

#КонецОбласти // Конец РасчетПоказателейРаботыОператоровWMS

#КонецОбласти

#КонецОбласти

#КонецОбласти
