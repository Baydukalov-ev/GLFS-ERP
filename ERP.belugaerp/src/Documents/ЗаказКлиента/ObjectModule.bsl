
#Область ПрограммныйИнтерфейс

// Возвращает данные для создания 
//
// Параметры:
//  ВременноеОкно  - Структура - может содержать в себе не обязательные ключи:
//                 ВремяДоставкиС - Дата (тип Время) - начало временного окна доставки
//                 ВремяДоставкиПо - Дата (тип Время) - конец временного окна доставки
//  СрокДоставки - Число - срок доставки товаров со склада отправления до клиента (дней)
//
// Возвращаемое значение:
//  Структура
//
Функция бг_ДанныеЗаполненияТранспортнойИнформации(ВременноеОкно = Неопределено, СрокДоставки = 0) Экспорт
	
	ДанныеЗаполнения = бг_ТранспортнаяИнформация.ПараметрыЗаполненияТранспортнойИнформации();
	
	ДатаОтгрузкиДляТранспортнойИнформации = бг_ДатаОтгрузкиДляТранспортнойИнформации();
	
	СекундВСутках = 86400;
	ПлановаяДатаДоставкиС  = НачалоДня(ДатаОтгрузкиДляТранспортнойИнформации + СрокДоставки * СекундВСутках);
	ПлановаяДатаДоставкиПо = КонецДня(ДатаОтгрузкиДляТранспортнойИнформации + СрокДоставки * СекундВСутках);
	
	Если ТипЗнч(ВременноеОкно) = Тип("Структура") Тогда
		
		ПустаяДата = Дата(1, 1, 1);
		Если ВременноеОкно.Свойство("ВремяДоставкиС") Тогда
			ПлановаяДатаДоставкиС =
				НачалоДня(ПлановаяДатаДоставкиС) + (ВременноеОкно.ВремяДоставкиС - ПустаяДата);
		КонецЕсли;
		
		Если ВременноеОкно.Свойство("ВремяДоставкиПо") И ЗначениеЗаполнено(ВременноеОкно.ВремяДоставкиПо) Тогда
			ПлановаяДатаДоставкиПо =
				НачалоДня(ПлановаяДатаДоставкиПо) + (ВременноеОкно.ВремяДоставкиПо - ПустаяДата);
		КонецЕсли;		
			
	КонецЕсли;
		
	ДанныеЗаполнения.Вставить("ПлановаяДатаДоставкиС", ПлановаяДатаДоставкиС);
	ДанныеЗаполнения.Вставить("ПлановаяДатаДоставкиПо", ПлановаяДатаДоставкиПо);
	ДанныеЗаполнения.Вставить("Перевозчик", Организация);
	ДанныеЗаполнения.Вставить("Заказчик", Организация);
	ВидПеревозки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "бг_ВидПеревозки");
	
	Если ДополнительныеСвойства.Свойство("ВидПеревозки") Тогда
		// Вид перевозки, отличный от указанного в договоре может быть задан, например,
		// при формировании заказа клиента ВГО из АРМа формирования заказов по заявкам клиентов ВГО.
		ВидПеревозки = ДополнительныеСвойства.ВидПеревозки; 
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидПеревозки) Тогда
		ВидПеревозки = бг_КонстантыПовтИсп.ЗначениеКонстанты("ВидПеревозкиАвто");
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("ВидПеревозки", ВидПеревозки);
	
	Возврат ДанныеЗаполнения;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ДополнительныеСвойства.Свойство("адаптер_ЭтоЗагрузкаДанных") Тогда
		Возврат;
	КонецЕсли;
	
	бг_ПроверитьВозможностьЗаписи(Отказ);
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	бг_ЗаполнитьТаблицуИзменений();
	
	ЭкспортныйЗаказ = бг_УчетАлкоголя.ЭтоЭкспортнаяПродажа(ЭтотОбъект);
	Если ЭтоНовый() И ЭкспортныйЗаказ Тогда
		Статус = Перечисления.СтатусыЗаказовКлиентов.НеСогласован;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		И Не бг_ДолгосрочныйРезерв Тогда
		
		бг_Номенклатура.ПроверитьЗаполнениеВидаАлкогольнойПродукцииВТЧТовары(ЭтотОбъект, Отказ);
		
		Если бг_ИсточникЗаказа = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.WINELAB_HYBRIS Тогда
        	// Для интернет-заказов цены минимальные проверять не будем,
			// так как цены придут позже, только в консолидированном заказе.
		Иначе
			бг_РасчетСкидок.ПроверитьМинимальныеЦеныАлкогольнойПродукции(ЭтотОбъект, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	бг_ЗаполнитьРазницуСEDI();
	
	Если ЗначениеЗаполнено(бг_ЗаявкаКлиента) Тогда
		УстановитьПривилегированныйРежим(Истина);
		бг_ИсточникЗаказа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(бг_ЗаявкаКлиента, "ИсточникЗаказа");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;	
	
	Если РегистрыСведений.бг_ОчередьЗаявокКлиентовКОтправкеOrderSP.ПоЗаказуТребуетсяОтправкаOrderSP(ЭтотОбъект) Тогда
		ДанныеДоИзменения = бг_ДанныеДоИзменения();
		РегистрыСведений.бг_ОчередьЗаявокКлиентовКОтправкеOrderSP.ЗарегистрироватьЗаказКлиентаВОчередьКОтправкеOrderSP(
				ДанныеДоИзменения, ЭтотОбъект);
	КонецЕсли;

	Если Не ЭтоНовый() 
		И Не бг_ДолгосрочныйРезерв
		И Не Пользователи.РолиДоступны(
				"бг_РедактированиеЗаказовКлиентовБезСнятияСогласования",
				Пользователи.АвторизованныйПользователь()) Тогда
		бг_АннулироватьСогласованиеПриНеобходимости();
	КонецЕсли;
	
	бг_УпаковкиЕдиницыИзмерения.РассчитатьИтоговыеПоказателиПаллетизации(ЭтотОбъект);
	ЗаполнитьСлужебныеРеквизиты();

	бг_ПолныйРезерв = бг_ЗаполнитьПолныйРезерв(РежимЗаписи);
	
	бг_ЗаполнитьРеквизитыОтсрочкиПокупателю();
	
	бг_ЗаполнитьМенеджера();

	Если ЭтоНовый() Тогда
		бг_ДатаСоздания = ТекущаяДатаСеанса();
		Если ЗначениеЗаполнено(Склад) Тогда
			ПодразделениеСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "Подразделение");
			Если ЗначениеЗаполнено(ПодразделениеСклада) Тогда
				Подразделение = ПодразделениеСклада;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		Если бг_ЗаказыКлиентов.ЭтоЗаказРозничногоПокупателя(Ссылка) Тогда
			бг_ПроверитьДоступностьИзмененияЗаказаРозничногоПокупателя(Отказ);
		КонецЕсли;
		Если бг_ЗаказыКлиентов.ЭтоЗаказМагазина(Ссылка) Тогда
			бг_ПроверитьДоступностьИзмененияЗаказаМагазина(Ссылка, Отказ);
			Если Не Отказ И ПометкаУдаления Тогда
				бг_ОчиститьРеквизитыЗаказаМагазина();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	бг_РасчетСкидок.ЗаполнитьИнформационныеПоляСкидок(ЭтотОбъект);

	Если Не ЭтоНовый() Тогда
		ЗафиксироватьИзмененияПередЗаписью();
	КонецЕсли;
	
КонецПроцедуры

&После("ПриЗаписи")
Процедура бг_ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Или Отказ Тогда
		Возврат;
	КонецЕсли;

	бг_АктуализироватьЗаписьТранспортнойИнформации();
	
	Если ДополнительныеСвойства.Свойство("бг_ДобавитьЗаявкуКлиентаВОчередьКОтправкеOrderSP") Тогда
		РегистрыСведений.бг_ОчередьЗаявокКлиентовКОтправкеOrderSP.ДобавитьЗаявкуКлиентаВОчередьКОтправкеOrderSP(
			ДополнительныеСвойства.бг_ДобавитьЗаявкуКлиентаВОчередьКОтправкеOrderSP.ЗаявкаКлиента);
	КонецЕсли;
	
	Если бг_ИсточникЗаказа = ПредопределенноеЗначение("Перечисление.бг_ИсточникиЗагрузкиЗаказовКлиентов.EDI")
		И (бг_КонстантыПовтИсп.ЗначениеКонстанты("СоздаватьНоменклатуруПартнераПриЗаписиЗаказаКлиентаEDI",
			Организация) = Истина) Тогда
		
		РегистрыСведений.бг_ОбъектыДляОтложеннойОбработки.ДобавитьОбъект(
			Ссылка,
			Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.СоздатьНоменклатуруПартнера);
	КонецЕсли;

	Если бг_КонстантыПовтИсп.ЗначениеКонстанты("ИспользоватьСогласованиеЗаказовПокупателей", Организация)
		И Не РегистрыСведений.бг_СогласованиеЗаказовКлиентов.ЗаказСогласован(Ссылка) Тогда
		РегистрыСведений.бг_ОбъектыДляОтложеннойОбработки.ДобавитьОбъект(Ссылка,
			Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.АвтоСогласованиеЗаказовКлиентов);
	КонецЕсли;
	
	Если бг_ЗаказыКлиентов.ЭтоЗаказРозничногоПокупателя(Ссылка) Тогда
		бг_ОбновитьЗаказМагазина(Отказ);
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		бг_ОткатитьПодчиненныеДокументы();
	КонецЕсли;

	Если Не ПометкаУдаления
		И ДополнительныеСвойства.Свойство("бг_ПересчитатьСкидкиВРеализацииТоваров") Тогда
		бг_ПересчитатьСкидкиВРеализацииТоваров();
	КонецЕсли;
	
КонецПроцедуры

&Перед("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	
	бг_ПроверитьЗаполнениеТранспортнойИнформации(Отказ);
	бг_ПроверитьПревышениеЛимитаОтгрузкиКлиенту();		

КонецПроцедуры

&После("ОбработкаПроведения")
Процедура бг_ОбработкаПроведенияПосле(Отказ, РежимПроведения)
	
	бг_ОтразитьДополнительныеСведенияЗаказаКлиента(Отказ);
	Если Не бг_ЗаказыКлиентов.НачальныеТоварыЗаполнены(Ссылка) Тогда
		бг_ЗаказыКлиентов.ЗаполнитьНачальныеТовары(Ссылка, Товары.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаУдаленияПроведения")
Процедура бг_ОбработкаУдаленияПроведения(Отказ)
	
	РегистрыСведений.бг_ДополнительныеСведенияПоЗаказамКлиентов.ОтразитьДополнительныеСведенияЗаказаКлиента(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка), Отказ, Истина);
		
КонецПроцедуры

&После("ОбработкаПроверкиЗаполнения")
Процедура бг_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты.Найти("ДатаОтгрузки") = Неопределено Тогда
		ПроверяемыеРеквизиты.Добавить("ДатаОтгрузки");
	КонецЕсли;

	Если ЗначениеЗаполнено(бг_Магазин)
		И Не ЗначениеЗаполнено(бг_ЗаказРозничногоПокупателя) Тогда
		ПроверяемыеРеквизиты.Добавить("бг_ВариантОплаты");
	КонецЕсли;
	
	Если бг_УчетАлкоголя.ПродажаАлкогольнойПродукции(ЭтотОбъект)
		И Не бг_ДолгосрочныйРезерв Тогда
		бг_УчетАлкоголя.ПроверитьПунктНазначенияИЛицензиюВДокументе(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ТоварыУчетВРазрезеПаллет = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
		Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура"),
		"бг_УчетОстатковИРезервовВРазрезеУпаковокПаллет");
		
	Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
		
		СтрокаТовары = Товары[ТекИндекс]; // СтрокаТабличнойЧасти
		
		АдресОшибки = " " + НСтр("ru = 'в строке %НомерСтроки% списка ""Товары""';
								|en = 'in line %НомерСтроки% of the ""Goods"" list'");
		АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрокаТовары.НомерСтроки);
		
		// Упаковка (паллета) для продукции, по которой ведется учет остатков и резервов в разрезе упаковок,
		// обязательна для заполнения в строках без признака Отменено.
		Если Не СтрокаТовары.Отменено 
			И ЗначениеЗаполнено(СтрокаТовары.Номенклатура)
			И ТоварыУчетВРазрезеПаллет[СтрокаТовары.Номенклатура].бг_УчетОстатковИРезервовВРазрезеУпаковокПаллет
			И Не ЗначениеЗаполнено(СтрокаТовары.бг_УпаковкаПаллета) Тогда
		
			ТекстОшибки = НСтр("ru = 'Необходимо указать упаковку (паллету)';
								|en = 'Package (pallet) is required'");
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовары.НомерСтроки, "бг_УпаковкаПаллета"),
				,
				Отказ);
		
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)

	Если ЗначениеЗаполнено(Договор) Тогда
		ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокРасчетов");
	КонецЕсли;
	
	бг_ДатаСоздания = '00010101';
	бг_ЗагруженИзУПП = Ложь;
	бг_ЗаявкаКлиента = Неопределено;
	бг_КодыСтрокБюджета = "";
	бг_ИсточникЗаказа = Неопределено;
	бг_НомерДокументаУПП = "";
	бг_ДоступнаяСуммоваяСкидка = 0;
	бг_ПолныйРезерв = Ложь;
	бг_КорректировкаОтсрочкиПлатежа = 0;
	бг_ГУИДЗаказаСПортала = "";
	
	Для каждого СтрокаТЧ Из Товары Цикл
		СтрокаТЧ.бг_КодСтрокиЗаявки = "";	
		СтрокаТЧ.бг_КодПозицииПредзаказаКлиента = "";	
		СтрокаТЧ.бг_НомерПредзаказаКлиента = "";
		СтрокаТЧ.бг_ДатаОтгрузкиЗаказаКлиентаИсточникаОбеспечения = '00010101';
		СтрокаТЧ.бг_ЗаказКлиентаИсточникОбеспечения = Неопределено;
		СтрокаТЧ.бг_ЗаказПоставщикуИсточникОбеспечения = Неопределено;
		СтрокаТЧ.бг_РаспределятьСуммовуюСкидку = Ложь;
		СтрокаТЧ.бг_ТребуемаяЦена = 0;
		СтрокаТЧ.бг_ЦенаEDI = 0;
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_ОткатитьПодчиненныеДокументы()

	ПодчиненныеДокументы = Документы.ЗаказКлиента.бг_ПодчиненныеДокументы(Ссылка);
	
	бг_РаботаСДокументами.ПометитьНаУдалениеПодчиненныеДокументы(
		ПодчиненныеДокументы, 
		"битОтражениеФактаПоРасходномуОрдеру");
	
	бг_РаботаСДокументами.ПометитьНаУдалениеПодчиненныеДокументы(
		ПодчиненныеДокументы, 
		"РасходныйОрдерНаТовары");
	
КонецПроцедуры

Процедура бг_ПроверитьВозможностьЗаписи(Отказ)
	
	Если ЭтоНовый() Тогда
		Возврат;	
	КонецЕсли;
	
	бг_ТипВнешнейСкладскойСистемы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "бг_ТипВнешнейСкладскойСистемы");
	
	Если бг_ИсточникЗаказа = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.WINELAB_HYBRIS
		И Не Документы.ЗаказКлиента.бг_РазрешеноИзменениеЗаказовHybris() Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение документа %1 запрещено. Получен от Hybris.'"),
			Ссылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, , , Отказ);
		Возврат;
	КонецЕсли;
	
	ЗапрещеноИзменениеЗаказовПереданныхНаСборку = 
		Документы.ЗаказКлиента.бг_ЗаказПереданНаСборку(Ссылка)
		И Не Документы.ЗаказКлиента.бг_РазрешеноИзменениеЗаказовПереданныхНаСборку();

	Если ЗапрещеноИзменениеЗаказовПереданныхНаСборку
		И бг_ТипВнешнейСкладскойСистемы = Перечисления.бг_ТипыВнешнихСкладскихСистем.Solvo
		И РегистрыСведений.бг_ДополнительныеСведенияПоЗаказамКлиентов.ЕстьРеализацияТоваровУслуг(Ссылка) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение документа %1 запрещено. По заказу есть оформленная Реализация товаров услуг.'"),
			Ссылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, , , Отказ);
		Возврат;
	КонецЕсли;

	Если ЗапрещеноИзменениеЗаказовПереданныхНаСборку
		И бг_ТипВнешнейСкладскойСистемы <> Перечисления.бг_ТипыВнешнихСкладскихСистем.Solvo Тогда		
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменение документа %1 запрещено. Заказ передан на сборку.'"),
			Ссылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, , , Отказ);
	КонецЕсли;

	
КонецПроцедуры

Функция бг_ДатаОтгрузкиДляТранспортнойИнформации()

	Если НеОтгружатьЧастями И ЗначениеЗаполнено(ДатаОтгрузки) Тогда
		
		Возврат ДатаОтгрузки;
		
	Иначе
		
		Для каждого СтрокаТовары Из Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТовары.ДатаОтгрузки) Тогда
				Возврат СтрокаТовары.ДатаОтгрузки;
			КонецЕсли;	
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат НачалоДня(ТекущаяДатаСеанса());

КонецФункции

Процедура бг_ПроверитьЗаполнениеТранспортнойИнформации(Отказ)
	
	Если Не (ЗначениеЗаполнено(Организация) И бг_УчетАлкоголя.ЭтоЭкспортнаяПродажа(ЭтотОбъект)) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверятьЗаполнениеТранспортнойИнформацииПродажи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Организация,
		"бг_ПроверятьЗаполнениеТранспортнойИнформацииПродажи");
		
	Если Не ПроверятьЗаполнениеТранспортнойИнформацииПродажи Тогда
		Возврат;
	КонецЕсли;
	
	Если Не бг_ТранспортнаяИнформация.ТранспортнаяИнформацияСоздана(Ссылка) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Не создана транспортная информация по заказу. Проведение невозможно.'"),
			Ссылка,
			, // Поле
			, // ПутьКДанным
			Отказ);
		
	Иначе
		ЗаписьТранспортнойИнформации =
			бг_ТранспортнаяИнформация.СоздатьНайтиЗаписьТранспортнойИнформации(Ссылка);
		
		Если Не ЗначениеЗаполнено(ЗаписьТранспортнойИнформации.ВидПеревозки) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='Не задан вид перевозки в транспортной информации по заказу. Проведение невозможно.'"),
				Ссылка,
				, // Поле
				, // ПутьКДанным
				Отказ);
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура бг_АктуализироватьЗаписьТранспортнойИнформации()
	ЗаданоВремяДоставки = ЗначениеЗаполнено(ВремяДоставкиС)
					Или ЗначениеЗаполнено(ВремяДоставкиПо);
					
	Если Не ЗаданоВремяДоставки Тогда		
		ВременноеОкно = бг_ТранспортнаяЛогистика.ВремяРаботыПунктаНазначения(бг_ПунктНазначения);;
	Иначе
		ВременноеОкно = Новый Структура("ВремяДоставкиС, ВремяДоставкиПо", ВремяДоставкиС, ВремяДоставкиПо);
	КонецЕсли;
	
	СрокДоставки = бг_ТранспортнаяЛогистика.СрокДоставкиДоПунктаНазначения(Склад, бг_ПунктНазначения);
	ДанныеЗаполнения = бг_ДанныеЗаполненияТранспортнойИнформации(ВременноеОкно, СрокДоставки);
	
	Если ДанныеЗаполнения.ПлановаяДатаДоставкиС > ДанныеЗаполнения.ПлановаяДатаДоставкиПо Тогда
		СекундВСутках = 86400;
		ДанныеЗаполнения.ПлановаяДатаДоставкиПо = ДанныеЗаполнения.ПлановаяДатаДоставкиПо + СекундВСутках;
	КонецЕсли;
	
	ТекущаяТранспортнаяИнформация =
		бг_ТранспортнаяИнформация.СоздатьНайтиЗаписьТранспортнойИнформации(Ссылка, ДанныеЗаполнения);
		
	ИзмененаДатаДоставки = ТекущаяТранспортнаяИнформация.ПлановаяДатаДоставкиС <> ДанныеЗаполнения.ПлановаяДатаДоставкиС
			Или ТекущаяТранспортнаяИнформация.ПлановаяДатаДоставкиПо <> ДанныеЗаполнения.ПлановаяДатаДоставкиПо;
	
	Если Не ТекущаяТранспортнаяИнформация.РучнаяКорректировкаДатыДоставки И ИзмененаДатаДоставки Тогда
		ДанныеЗаполнения = Новый Структура("ПлановаяДатаДоставкиС, ПлановаяДатаДоставкиПо",
				ДанныеЗаполнения.ПлановаяДатаДоставкиС, ДанныеЗаполнения.ПлановаяДатаДоставкиПо);
		бг_ТранспортнаяИнформация.АктуализироватьЗаписьТранспортнойИнформации(Ссылка, ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура бг_ЗаполнитьРазницуСEDI()
	
	Для каждого СтрокаТЧ Из Товары Цикл   
		
		СтрокаТЧ.бг_РазницаСEDI = СтрокаТЧ.бг_ЦенаСоСкидкой - СтрокаТЧ.бг_ЦенаEDI;
		
	КонецЦикла;
	
КонецПроцедуры

Функция бг_ДанныеДоИзменения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	&СоставРеквизитов
		|ИЗ
		|	Документ.ЗаказКлиента КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.бг_КодСтрокиЗаявки КАК бг_КодСтрокиЗаявки,
		|	Таблица.ДатаОтгрузки КАК ДатаОтгрузки,
		|	Таблица.ВариантОбеспечения КАК ВариантОбеспечения,
		|	Таблица.Отменено КАК Отменено,
		|	Таблица.Количество КАК Количество
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Таблица.НомерСтроки";
	
	СоставРеквизитов = 
		"Статус, 
		|Проведен";
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СоставРеквизитов", СоставРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если ЭтотОбъект.ЭтоНовый() Тогда
		Реквизиты = Новый Структура(СоставРеквизитов);
		ЗаполнитьЗначенияСвойств(Реквизиты, ЭтотОбъект);
	Иначе
		Выборка = РезультатЗапроса[0].Выбрать();
		Выборка.Следующий();
		
		Реквизиты = Новый Структура(СоставРеквизитов);
		ЗаполнитьЗначенияСвойств(Реквизиты, Выборка);
	КонецЕсли;
	
	ДанныеДоИзменения = Новый Структура;
	
	ДанныеДоИзменения.Вставить("Реквизиты", Реквизиты);
	ДанныеДоИзменения.Вставить("Товары", РезультатЗапроса[1].Выгрузить());
	
	Возврат ДанныеДоИзменения;
	
КонецФункции

Процедура бг_ПроверитьПревышениеЛимитаОтгрузкиКлиенту()
	
	
КонецПроцедуры

Процедура бг_АннулироватьСогласованиеПриНеобходимости()
	
	ЗначенияРеквизитовДо = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Договор, бг_ПунктНазначения, СуммаДокумента");

	Если СуммаДокумента <> ЗначенияРеквизитовДо.СуммаДокумента
		Или Договор <> ЗначенияРеквизитовДо.Договор
		Или бг_ПунктНазначения <> ЗначенияРеквизитовДо.бг_ПунктНазначения Тогда
	
		Если РегистрыСведений.бг_НастройкиКорректировкиЗаказовБезСнятияСогласования.ОтменитьСогласование(Ссылка, 
			Дата) Тогда
			Возврат;
		КонецЕсли;
	
		НовоеСостояниеСогласования = Новый Структура;
		НовоеСостояниеСогласования.Вставить("РезультатСогласованияКК");
		НовоеСостояниеСогласования.Вставить("РезультатСогласованияСБ");
		НовоеСостояниеСогласования.Вставить("РезультатСогласованияФК");
		НовоеСостояниеСогласования.Вставить("КомментарийФК");
		НовоеСостояниеСогласования.Вставить("КомментарийКК");
		НовоеСостояниеСогласования.Вставить("КомментарийСБ");
		РегистрыСведений.бг_СогласованиеЗаказовКлиентов.ЗаписатьНовоеСостояние(Ссылка, НовоеСостояниеСогласования);
		
	КонецЕсли; 
	
КонецПроцедуры

Функция бг_ЗаполнитьПолныйРезерв(РежимЗаписи)
	
	Если Не РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	ПолныйРезерв = Ложь;
	
	Если Не бг_ЕстьНеОбеспеченныеТовары()
		И бг_ЕстьОбеспеченныеТовары() Тогда
		ПолныйРезерв = Истина;		
	КонецЕсли;
	
	Возврат ПолныйРезерв;
	
КонецФункции

Процедура бг_ОтразитьДополнительныеСведенияЗаказаКлиента(Отказ)
	
	ВсеСтрокиВЗаказеОтменены = бг_ЗаказыКлиентов.ВсеСтрокиВЗаказеОтменены(Ссылка);
	
	Если ВсеСтрокиВЗаказеОтменены Тогда
		РегистрыСведений.бг_ДополнительныеСведенияПоЗаказамКлиентов.ОтразитьДополнительныеСведенияЗаказаКлиента(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка), Отказ, Истина);
		Возврат;
	КонецЕсли;
	
	Если Отказ
		Или ДополнительныеСвойства.Свойство("бг_НеРегистрироватьПоказателиЗаказаКлиентаКОбновлению")
		И ДополнительныеСвойства.бг_НеРегистрироватьПоказателиЗаказаКлиентаКОбновлению = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если бг_ЗаказыКлиентов.ЕстьСтрокиКОтгрузкеВЗаказеКлиента(Ссылка) Тогда
		РегистрыСведений.бг_ОбъектыДляОтложеннойОбработки.ДобавитьОбъект(
			Ссылка,
			Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.ОтразитьДополнительныеСведенияЗаказаКлиента,,
			Новый ХранилищеЗначения(
				РегистрыСведений.бг_ДополнительныеСведенияПоЗаказамКлиентов.ПоказателиПоТипуДокумента(Ссылка)));
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗафиксироватьИзмененияПередЗаписью()
	
	ИзмененияДокумента = бг_ОбщегоНазначенияСервер.ИзмененияОбъекта(ЭтотОбъект,, Новый Структура("СкидкиНаценки"));
	
	Если ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
		
		Для Каждого ТабличнаяЧасть Из ИзмененияДокумента.ТабличныеЧасти Цикл
			
			Если ТабличнаяЧасть.Ключ = "СкидкиНаценки" Тогда
				
				ДополнительныеСвойства.Вставить("бг_ПересчитатьСкидкиВРеализацииТоваров");
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ПересчитатьСкидкиВРеализацииТоваров()
	
	ДокументыРеализацииПоЗаказу = бг_ЗаказыКлиентов.ДокументыРеализацииПоЗаказу(Ссылка);
	
	Для Каждого СтрокаДокумент Из ДокументыРеализацииПоЗаказу Цикл
		
		Если СтрокаДокумент.Проведен Тогда
			РегистрыСведений.бг_ОбъектыДляОтложеннойОбработки.ДобавитьОбъект(
				СтрокаДокумент.Ссылка,
				Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.ОтразитьДополнительныеСведенияЗаказаКлиента);
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

#Область ОтсрочкаПлатежа

Процедура бг_ЗаполнитьРеквизитыОтсрочкиПокупателю()
	
	КоличествоДнейОтсрочки = РегистрыСведений.бг_ОтсрочкиПлатежаПокупателям.ОтсрочкаПлатежаПоКонтрагенту(Контрагент,
		Договор, Соглашение, бг_ПунктНазначения);
																					
	КоличествоСекундВСутках = 86400;																					
	 бг_КоличествоДнейОтсрочки = КоличествоДнейОтсрочки;
	 бг_ДатаОплатыСУчетомОтсрочки = КонецДня(ДатаОтгрузки)  
		 + КоличествоСекундВСутках * КоличествоДнейОтсрочки 
		 + КоличествоСекундВСутках * бг_КорректировкаОтсрочкиПлатежа;		
	
КонецПроцедуры

#КонецОбласти

// Возвращает признак - есть ли в заказе клиента товарные позиции к обеспечению.
Функция бг_ЕстьНеОбеспеченныеТовары()
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Товары.ВариантОбеспечения КАК ВариантОбеспечения,
	                      |	Товары.Количество КАК Количество,
	                      |	Товары.Отменено КАК Отменено
	                      |ПОМЕСТИТЬ ВТ_Товары
	                      |ИЗ
	                      |	&Товары КАК Товары
	                      |ГДЕ
	                      |	Товары.Количество > 0
	                      |	И НЕ Товары.Отменено
	                      |	И Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.КОбеспечению)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Товары.ВариантОбеспечения КАК ВариантОбеспечения,
	                      |	ВТ_Товары.Количество КАК Количество,
	                      |	ВТ_Товары.Отменено КАК Отменено
	                      |ИЗ
	                      |	ВТ_Товары КАК ВТ_Товары");
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"ВариантОбеспечения,Количество,Отменено"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();

КонецФункции

// Возвращает признак - есть ли в заказе клиента обеспеченные товарные позиции.
//
Функция бг_ЕстьОбеспеченныеТовары()
		
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	Товары.ВариантОбеспечения КАК ВариантОбеспечения,
	                      |	Товары.Количество КАК Количество,
	                      |	Товары.Отменено КАК Отменено
	                      |ПОМЕСТИТЬ ВТ_Товары
	                      |ИЗ
	                      |	&Товары КАК Товары
	                      |ГДЕ
	                      |	Товары.Количество > 0
	                      |	И НЕ Товары.Отменено
	|	И Товары.ВариантОбеспечения в (
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить))
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Товары.ВариантОбеспечения КАК ВариантОбеспечения,
	                      |	ВТ_Товары.Количество КАК Количество,
	                      |	ВТ_Товары.Отменено КАК Отменено
	                      |ИЗ
	                      |	ВТ_Товары КАК ВТ_Товары");
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"ВариантОбеспечения,Количество,Отменено"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

Процедура ЗаполнитьСлужебныеРеквизиты()
	
	Если ЗначениеЗаполнено(ЭтотОбъект.бг_ПунктНазначения) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЭтотОбъект.бг_КаналПродаж = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(бг_ПунктНазначения, "КаналПродаж");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если ЭтотОбъект.бг_ИсточникЗаказа = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.EDI Тогда
		Для Каждого Строка Из Товары Цикл
			Строка.бг_ЗафиксированныйТовар = Истина;
		КонецЦикла;
	КонецЕсли;
	
	бг_ТребуетсяВизаСБ = 
		РегистрыСведений.бг_НастройкиСогласованияЗаказовКлиентов.НастройкиСогласования(ЭтотОбъект).ТребуетсяВизаСБ;
	
КонецПроцедуры

Процедура бг_ЗаполнитьМенеджера()
	
	Если Не ЗначениеЗаполнено(бг_ПунктНазначения) Тогда
		Возврат;
	КонецЕсли;
	
	ФизЛицо = РегистрыСведений.бг_МенеджерыПунктовНазначения.МенеджерПунктаНазначения(бг_ПунктНазначения, Дата);

	Если Не ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат;
	КонецЕсли;

	ОсновнойМенеджер = бг_ПользовательПоФизическомуЛицу(ФизЛицо);

	Если ЗначениеЗаполнено(ОсновнойМенеджер) Тогда
		Менеджер = ОсновнойМенеджер;	
	КонецЕсли; 
	
КонецПроцедуры

Функция бг_ПользовательПоФизическомуЛицу(ФизическоеЛицо)

	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;	

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Пользователи.Ссылка КАК Пользователь
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ФизическоеЛицо = &ФизическоеЛицо
	|	И НЕ Пользователи.ПометкаУдаления";

	Результат = Запрос.Выполнить();
	Выборка= Результат.Выбрать();

	 Пока Выборка.Следующий() Цикл
    		Возврат Выборка.Пользователь;
	КонецЦикла;

	Возврат Неопределено;

КонецФункции

Процедура бг_АктуализироватьДатуДоставкиТранспортнойИнформации()

	ПлановаяДатаДоставкиС = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ДополнительныеСвойства, "бг_ПлановаяДатаДоставкиС");
	ПлановаяДатаДоставкиПо = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		ДополнительныеСвойства, "бг_ПлановаяДатаДоставкиПо");
	
	ДатаДоставкиУказана = ЗначениеЗаполнено(ПлановаяДатаДоставкиС) И ЗначениеЗаполнено(ПлановаяДатаДоставкиПо);
	Если бг_ДатаОтгрузкиИзменилась() Или ДатаДоставкиУказана Тогда

		Если Не ДатаДоставкиУказана Тогда
			ПлановаяДатаДоставкиС = НачалоДня(ДатаОтгрузки);
			ПлановаяДатаДоставкиПо = КонецДня(ДатаОтгрузки);
		КонецЕсли;
		
		ДанныеЗаполнения = Новый Структура(
			"ПлановаяДатаДоставкиС, ПлановаяДатаДоставкиПо", ПлановаяДатаДоставкиС, ПлановаяДатаДоставкиПо);
		
		бг_ТранспортнаяИнформация.АктуализироватьЗаписьТранспортнойИнформации(Ссылка, ДанныеЗаполнения);

	КонецЕсли;

КонецПроцедуры

Функция бг_ДатаОтгрузкиИзменилась()

	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Ложь; 
	КонецЕсли;

	ДатаОтгрузкиИзменена = Ложь; 

	Если ДополнительныеСвойства.Свойство("СтруктураИзменений") 
		И ДополнительныеСвойства.СтруктураИзменений.Количество() > 0
		И ДополнительныеСвойства.СтруктураИзменений.Свойство("Реквизиты") Тогда

		Для Каждого СтрокаРеквизита Из ДополнительныеСвойства.СтруктураИзменений.Реквизиты Цикл
			Если СтрокаРеквизита.Имя = "ДатаОтгрузки" Тогда 
				ДатаОтгрузкиИзменена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

	Возврат ДатаОтгрузкиИзменена;

КонецФункции

Процедура бг_ЗаполнитьТаблицуИзменений()

	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;

	СтруктураИзменений = ОбщегоНазначенияУТ.ИзмененияДокумента(ЭтотОбъект);

	ДополнительныеСвойства.Вставить("СтруктураИзменений", СтруктураИзменений);

КонецПроцедуры

#Область ЗаказРозничногоПокупателя

Процедура бг_ПроверитьДоступностьИзмененияЗаказаРозничногоПокупателя(Отказ)
	
	ЗаказМагазина = бг_ЗаказыКлиентов.НайтиЗаказМагазина(Ссылка);
	Если ЗначениеЗаполнено(ЗаказМагазина) Тогда
		бг_ПроверитьДоступностьИзмененияЗаказаМагазина(ЗаказМагазина, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ПроверитьДоступностьИзмененияЗаказаМагазина(ЗаказМагазина, Отказ)
	
	Если ДополнительныеСвойства.Свойство("бг_ЭтоОбновлениеЗаказаWMS")
		И ДополнительныеСвойства.бг_ЭтоОбновлениеЗаказаWMS Тогда
		
		Возврат;
	КонецЕсли;
	
	РазрешеноИзменениеЗаказовПереданныхНаСборку =
		Документы.ЗаказКлиента.бг_РазрешеноИзменениеЗаказовПереданныхНаСборку();
	Если Документы.ЗаказКлиента.бг_ЗаказПереданНаСборку(ЗаказМагазина)
		И Не РазрешеноИзменениеЗаказовПереданныхНаСборку Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Заказ магазина передан на сборку. 
				|Изменение данных заказа клиента запрещено.'"),
			Ссылка,
			, // Поле
			, // ПутьКДанным
			Отказ);
		
	ИначеЕсли Не Пользователи.РолиДоступны("бг_РедактированиеЗаказовМагазина")
		И Не РазрешеноИзменениеЗаказовПереданныхНаСборку Тогда
			
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'На основании заказа клиента создан заказ магазина. 
				|Изменение данных заказа клиента запрещено.'"),
			Ссылка,
			, // Поле
			, // ПутьКДанным
			Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ОбновитьЗаказМагазина(Отказ)
	
	ЗаказМагазина = бг_ЗаказыКлиентов.НайтиЗаказМагазина(Ссылка);
	Если ЗаказМагазина = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РазрешеноИзменениеЗаказовПереданныхНаСборку =
		Документы.ЗаказКлиента.бг_РазрешеноИзменениеЗаказовПереданныхНаСборку();
	Если Документы.ЗаказКлиента.бг_ЗаказПереданНаСборку(ЗаказМагазина)
		И Не РазрешеноИзменениеЗаказовПереданныхНаСборку Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Заказ магазина передан на сборку. 
				|Изменение данных заказа клиента запрещено.'"),
			Ссылка,
			, // Поле
			, // ПутьКДанным
			Отказ);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("бг_ОбновитьСкидкиВЗаказеМагазина")
		И ДополнительныеСвойства.бг_ОбновитьСкидкиВЗаказеМагазина Тогда
		
		ДанныеДляПересчета = Товары.Выгрузить(, 
			"НомерСтроки, ПроцентРучнойСкидки, СуммаРучнойСкидки, 
			|	ПроцентАвтоматическойСкидки, СуммаАвтоматическойСкидки");
			
		бг_ЗаказыКлиентов.ОбновитьСкидкиВЗаказеМагазина(
			Ссылка, 
			ЗаказМагазина, 
			ДанныеДляПересчета);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ОчиститьРеквизитыЗаказаМагазина()
	
	бг_ЗаказРозничногоПокупателя = Неопределено;
	бг_ДоговорРозничногоПокупателя = Неопределено;
	бг_РозничныйПокупатель = Неопределено;
	бг_Магазин = Неопределено;
	бг_ВариантОплаты = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
