
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	Если бг_ОбщегоНазначенияСервер.ОтменитьЗагрузкуОбъекта(ЗагружаемыйОбъект, СтруктураОбъекта, Неопределено, Неопределено, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗагружаемыйОбъект.ЭтоНовый() Тогда
		ЗагружаемыйОбъект.Заполнить(Неопределено);
	КонецЕсли;
	
	СтруктураОбъекта.Вставить("Контрагент", СтруктураОбъекта.Владелец);
	СтруктураОбъекта.Удалить("Владелец");
	
	СтруктураОбъекта.Вставить("бг_ВидВзаиморасчетов", СтруктураОбъекта.ВидВзаиморасчетов);
	СтруктураОбъекта.Удалить("ВидВзаиморасчетов");
	
	Если СтруктураОбъекта.ВидДоговора.ЗначениеПеречисления = "СПоставщиком"
		И СтруктураОбъекта.НеЯвляетсяРезидентом Тогда
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.Импорт;
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту;
	ИначеЕсли СтруктураОбъекта.ВидДоговора.ЗначениеПеречисления = "СПоставщиком" Тогда
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком;
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	ИначеЕсли СтруктураОбъекта.ВидДоговора.ЗначениеПеречисления = "СПокупателем" Тогда
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем;
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	ИначеЕсли СтруктураОбъекта.ВидДоговора.ЗначениеПеречисления = "СКомитентом" Тогда
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.СКомитентом;
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;
	ИначеЕсли СтруктураОбъекта.ВидДоговора.ЗначениеПеречисления = "СКомиссионером" Тогда
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.СКомиссионером;
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию;
	ИначеЕсли СтруктураОбъекта.ВидДоговора.ЗначениеПеречисления = "Прочее" Тогда
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.ПустаяСсылка();
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	Иначе
		ЗагружаемыйОбъект.ТипДоговора = Перечисления.ТипыДоговоров.ПустаяСсылка();
		ЗагружаемыйОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	КонецЕсли;
	
	Если СтруктураОбъекта.ВалютаВзаиморасчетов = Неопределено Тогда
		ЗагружаемыйОбъект.ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
		СтруктураОбъекта.ВалютаВзаиморасчетов = ЗагружаемыйОбъект.ВалютаВзаиморасчетов;
	Иначе
		
		ВалютаВзаиморасчетов = бг_ОбщегоНазначенияСервер.СсылкаНаКлассификатор(СтруктураОбъекта.ВалютаВзаиморасчетов, "Код");
		
		Если ВалютаВзаиморасчетов <> Неопределено Тогда
			ЗагружаемыйОбъект.ВалютаВзаиморасчетов = ВалютаВзаиморасчетов;
			СтруктураОбъекта.ВалютаВзаиморасчетов = ЗагружаемыйОбъект.ВалютаВзаиморасчетов;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗагружаемыйОбъект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует;
	ЗагружаемыйОбъект.НаименованиеДляПечати = СтруктураОбъекта.Наименование;
	ЗагружаемыйОбъект.ДатаНачалаДействия = СтруктураОбъекта.Дата;
	ЗагружаемыйОбъект.ДатаОкончанияДействия = СтруктураОбъекта.СрокДействия;
	ЗагружаемыйОбъект.ВариантОформленияЗакупок = Перечисления.ВариантыОформленияЗакупок.НеРазделять;
	
	Если СтруктураОбъекта.ВедениеВзаиморасчетов.ЗначениеПеречисления = "ПоДоговоруВЦелом"
		И Не СтруктураОбъекта.ВестиПоДокументамРасчетовСКонтрагентом Тогда
		ЗагружаемыйОбъект.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	ИначеЕсли СтруктураОбъекта.ВедениеВзаиморасчетов.ЗначениеПеречисления = "ПоДоговоруВЦелом"
		И СтруктураОбъекта.ВестиПоДокументамРасчетовСКонтрагентом Тогда
		ЗагружаемыйОбъект.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным;
	ИначеЕсли СтруктураОбъекта.ВедениеВзаиморасчетов.ЗначениеПеречисления = "ПоЗаказам" Тогда
		ЗагружаемыйОбъект.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказам;
	Иначе
		ЗагружаемыйОбъект.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗагружаемыйОбъект.ВалютаВзаиморасчетов <> ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета()
		И Не СтруктураОбъекта.РасчетыВУсловныхЕдиницах Тогда
		ЗагружаемыйОбъект.ОплатаВВалюте = Истина;
	Иначе
		ЗагружаемыйОбъект.ОплатаВВалюте = Ложь;
	КонецЕсли;
	
	Если СтруктураОбъекта.УчетАгентскогоНДС Тогда
		ЗагружаемыйОбъект.НалогообложениеНДСОпределяетсяВДокументе = Ложь;
		ЗагружаемыйОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НалоговыйАгентПоНДС;
	Иначе
		ЗагружаемыйОбъект.НалогообложениеНДСОпределяетсяВДокументе = Истина;
		ЗагружаемыйОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка();
	КонецЕсли;
	
	Если СтруктураОбъекта.ВидАгентскогоДоговора.ЗначениеПеречисления = "Аренда" Тогда
		ЗагружаемыйОбъект.ВидАгентскогоДоговора = Перечисления.ВидыАгентскихДоговоров.Аренда;
	ИначеЕсли СтруктураОбъекта.ВидАгентскогоДоговора.ЗначениеПеречисления = "РеализацияИмущества" Тогда
		ЗагружаемыйОбъект.ВидАгентскогоДоговора = Перечисления.ВидыАгентскихДоговоров.РеализацияИмущества;
	ИначеЕсли СтруктураОбъекта.ВидАгентскогоДоговора.ЗначениеПеречисления = "Нерезидент" Тогда
		ЗагружаемыйОбъект.ВидАгентскогоДоговора = Перечисления.ВидыАгентскихДоговоров.Нерезидент;
	Иначе
		ЗагружаемыйОбъект.ВидАгентскогоДоговора = Перечисления.ВидыАгентскихДоговоров.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураОбъекта.ВидАгентскогоДоговора = ЗагружаемыйОбъект.ВидАгентскогоДоговора;
	
	ЗагружаемыйОбъект.ЗакупкаПодДеятельностьОпределяетсяВДокументе = Истина;
	ЗагружаемыйОбъект.СпособДоставки = Перечисления.СпособыДоставки.ОпределяетсяВРаспоряжении;
	ЗагружаемыйОбъект.ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.РазделенаТолькоПоНакладным;
	ЗагружаемыйОбъект.ВариантОформленияЗакупок = Перечисления.ВариантыОформленияЗакупок.НеРазделять;
	
КонецПроцедуры

Процедура ЗаписатьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтандартнаяОбработка) Экспорт
	
	ЗагружаемыйОбъект.Партнер = ЗагружаемыйОбъект.Контрагент.Партнер;
	
КонецПроцедуры

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Реквизиты = ВыгружаемыеРеквизиты();
	
	ДобавитьРеквизитыЧерезТочкуКВыгрузке(Реквизиты);
	
	адаптер_НастройкиОбмена.УстановитьРеквизиты(
		РеквизитыИСвойства, 
		РеквизитыИСвойства.МетаданныеОбъекта, 
		Реквизиты);

	ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства);
	
КонецПроцедуры

Функция ПолучитьКлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения, ИсточникОбъект = Неопределено) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	КлючМаршрутизации = 
		адаптер_ОбработчикиСобытийСтандартный.ПолучитьКлючМаршрутизацииИсходящегоСообщения(ДанныеСообщения);
	
	КлючМаршрутизации = КлючМаршрутизации + ".ERP";
	
	ПостфиксКлючаМаршрутизации = ПостфиксКлючаМаршрутизации(ДанныеСообщения, ИсточникОбъект);

	Если Не ПустаяСтрока(ПостфиксКлючаМаршрутизации) Тогда
		КлючМаршрутизации = КлючМаршрутизации + ПостфиксКлючаМаршрутизации;
	КонецЕсли;

	Возврат КлючМаршрутизации;
	
КонецФункции

#КонецОбласти // Конец ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()

	ВыгружаемыеРеквизиты = Новый Массив;
	
	ВыгружаемыеРеквизиты.Добавить("Дата");
	ВыгружаемыеРеквизиты.Добавить("ДатаНачалаДействия");
	ВыгружаемыеРеквизиты.Добавить("ДатаОкончанияДействия");
	ВыгружаемыеРеквизиты.Добавить("бг_ВидВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("бг_Соглашение");
	ВыгружаемыеРеквизиты.Добавить("ВалютаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("ВидАгентскогоДоговора");
	ВыгружаемыеРеквизиты.Добавить("ВидЦенУчетный");
	ВыгружаемыеРеквизиты.Добавить("Комментарий");
	ВыгружаемыеРеквизиты.Добавить("Контрагент");
	ВыгружаемыеРеквизиты.Добавить("Наименование");
	ВыгружаемыеРеквизиты.Добавить("НаименованиеДляПечати");
	ВыгружаемыеРеквизиты.Добавить("НалогообложениеНДС");
	ВыгружаемыеРеквизиты.Добавить("Номер");
	ВыгружаемыеРеквизиты.Добавить("ОплатаВВалюте");
	ВыгружаемыеРеквизиты.Добавить("Организация");
	ВыгружаемыеРеквизиты.Добавить("Партнер");
	ВыгружаемыеРеквизиты.Добавить("ПометкаУдаления");
	ВыгружаемыеРеквизиты.Добавить("ПорядокРасчетов");
	ВыгружаемыеРеквизиты.Добавить("Согласован");
	ВыгружаемыеРеквизиты.Добавить("Статус");
	ВыгружаемыеРеквизиты.Добавить("СтатьяДвиженияДенежныхСредств");
	ВыгружаемыеРеквизиты.Добавить("ТипДоговора");
			
	Возврат ВыгружаемыеРеквизиты;

КонецФункции

Процедура ДобавитьРеквизитыЧерезТочкуКВыгрузке(Реквизиты)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Реквизиты.Добавить(
		адаптер_НастройкиОбмена.ОписаниеРеквизита(
			"Соглашение_ВидЦен", 
			Новый ОписаниеТипов("СправочникСсылка.ВидыЦен"), 
			"бг_Соглашение.ВидЦен"));
			
КонецПроцедуры

Процедура ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства)

	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.Организации,
		"бг_Тикер");
				
КонецПроцедуры

Функция ПостфиксКлючаМаршрутизации(ДанныеСообщения, ИсточникОбъект = Неопределено)
	
	ПостфиксКлючаМаршрутизации = "";
	
	Если ДанныеСообщения.Свойство("Объект") Тогда
		ОбъектСсылка = ДанныеСообщения.Объект;
	Иначе
		ОбъектСсылка = Неопределено;
	КонецЕсли;
	
	#Область ДляСвязанныхОбъектовКаналаПродажОпт
	Контрагент = Справочники.Контрагенты.бг_КонтрагентСвязанногоОбъекта(ИсточникОбъект, ОбъектСсылка);
	КаналПродаж = Справочники.битКаналыПродаж.КаналПродаж(Контрагент);
	КлючКаналаПродажОпт = Справочники.битКаналыПродаж.КлючКаналаПродаж(КаналПродаж);
	
	Если Не ПустаяСтрока(КлючКаналаПродажОпт) Тогда
		ПостфиксКлючаМаршрутизации = "." + КлючКаналаПродажОпт;
	КонецЕсли;
	#КонецОбласти
	
	Возврат ПостфиксКлючаМаршрутизации;
	
КонецФункции

#КонецОбласти // Конец СлужебныеПроцедурыИФункции
