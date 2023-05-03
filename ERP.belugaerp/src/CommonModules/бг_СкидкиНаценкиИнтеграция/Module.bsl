
#Область ПрограммныйИнтерфейс

#Область ВыгрузкаДанных

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Реквизиты = ВыгружаемыеРеквизиты();
	
	адаптер_НастройкиОбмена.УстановитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		Реквизиты);
	
	ДобавитьПроизвольныеРеквизитыКВыгрузке(РеквизитыИСвойства);
	
КонецПроцедуры

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный, адаптер_РаботаСДаннымиИБ;
	
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ДанныеОбъекта = адаптер_ОбработчикиСобытийСтандартный.ПолучитьДанныеВыгружаемогоОбъекта(
						Объект, 
						ДанныеСообщения);
	
	Если ДанныеОбъекта.Реквизиты.Количество() > 0 Тогда
		
		РеквизитыОбъекта = ДанныеОбъекта.Реквизиты[0];
		
		ПараметрыВыполненияЗапросов = адаптер_РаботаСДаннымиИБ.ПолучитьПараметрыВыполненияЗапросов(
										Объект, 
										ДанныеСообщения);
		
		ЗаполнитьОтборы(
			РеквизитыОбъекта, 
			Объект, 
			ПараметрыВыполненияЗапросов, 
			ДанныеСообщения);
			
		ЗаполнитьПризнакСкидкаЧКН(
			РеквизитыОбъекта, 
			Объект);
		
	КонецЕсли;
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Функция ВыполненыУсловияВыгрузкиОбъекта(ДанныеСообщения) Экспорт
	
	Результат = Истина;
	
	ДанныеОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеСообщения.Объект, "ЭтоГруппа, Родитель");
	Если ДанныеОбъекта.ЭтоГруппа Тогда
		ТекстОшибки = НСтр("ru = 'Группы скидок не выгружаются'");
		ДанныеСообщения.ТекстОшибки = ТекстОшибки;
		Результат = Ложь;
	ИначеЕсли ДанныеОбъекта.Родитель <> бг_КонстантыПовтИсп.ЗначениеКонстанты("ГруппаСкидокЧКН") Тогда
		ТекстОшибки = НСтр("ru = 'Выгружаются только скидки из группы ЧКН'");
		ДанныеСообщения.ТекстОшибки = ТекстОшибки;
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ЗагрузкаДанных

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураОбъекта.Вставить("Родитель", Справочники.СкидкиНаценки.КорневаяГруппа);
	Если СтруктураОбъекта.Свойство("Организация") Тогда
		СтруктураОбъекта.Вставить("бг_Организация", СтруктураОбъекта.Организация);
		СтруктураОбъекта.Удалить("Организация");
	КонецЕсли;
	Если СтруктураОбъекта.Свойство("КодСтроки") Тогда
		СтруктураОбъекта.Вставить("бг_КодСтрокиБюджета", СтруктураОбъекта.КодСтроки);
		СтруктураОбъекта.Удалить("КодСтроки");
	КонецЕсли;
	Если СтруктураОбъекта.Свойство("ТипСкидкиНаценки") Тогда
		СтруктураОбъекта.Вставить("бг_ТипСкидкиНаценкиCRM", СтруктураОбъекта.ТипСкидкиНаценки);
		СтруктураОбъекта.Удалить("ТипСкидкиНаценки");
	КонецЕсли;
	Если СтруктураОбъекта.Свойство("БлокироватьСуммовыеСкидки") Тогда
		СтруктураОбъекта.Вставить("бг_БлокируетСуммовыеСкидки", СтруктураОбъекта.БлокироватьСуммовыеСкидки);
		СтруктураОбъекта.Удалить("БлокироватьСуммовыеСкидки");
	КонецЕсли;
	
	ЗагружаемыйОбъект.бг_ЦеновыеГруппы.Очистить();
	ЗагружаемыйОбъект.бг_Исключения.Очистить();
	ЗагружаемыйОбъект.бг_Ограничения.Очистить();
		
	адаптер_ОбработчикиСобытийСтандартный.ЗаполнитьЗагружаемыйОбъект(
		ЗагружаемыйОбъект, 
		СтруктураОбъекта, 
		СписокСвойств, 
		ИсключаяСвойства);
		
	ЗагружаемыйОбъект.СпособПримененияСкидки = Перечисления.СпособыПримененияСкидокНаценок.ПрименитьВМоментРасчетаСкидокНаценок;
	ЗагружаемыйОбъект.бг_Комментарий = ЗагружаемыйОбъект.Наименование;
	ЗагружаемыйОбъект.СпособПредоставления = Перечисления.СпособыПредоставленияСкидокНаценок.Процент;
	ЗагружаемыйОбъект.ВариантОтбораНоменклатуры = Перечисления.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.БезОграничений;

	ЗагружаемыйОбъект.бг_ИсточникЦеновойГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.SKU_MT;
	
	ЗагружаемыйОбъект.ДополнительныеСвойства.Вставить("ПериодОтгрузкиНачало", СтруктураОбъекта.ПериодОтгрузкиНачало);
	ЗагружаемыйОбъект.ДополнительныеСвойства.Вставить("ПериодОтгрузкиКонец", СтруктураОбъекта.ПериодОтгрузкиКонец);
	
	ЗагружаемыйОбъект.ДополнительныеСвойства.Вставить("ПолучателиСкидок", ПолучателиСкидок(СтруктураОбъекта));
	
	ЗаполнитьЦеновыеГруппы(ЗагружаемыйОбъект, СтруктураОбъекта);
КонецПроцедуры

Процедура ЗаписатьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	СтандартнаяОбработка = Ложь;
	адаптер_ОбработчикиСобытийСтандартный.ЗаписатьЗагружаемыйОбъект(ЗагружаемыйОбъект);
	Справочники.адаптер_ИсходящиеСообщения.ЗарегистрироватьИсходящееСообщениеПриЗаписи(
		ЗагружаемыйОбъект,
		,
		,
		ЗагружаемыйОбъект);
		
	ЗаписатьДействиеСкидок(ЗагружаемыйОбъект.Ссылка, 
		ЗагружаемыйОбъект.ДополнительныеСвойства.ПолучателиСкидок, 
		ЗагружаемыйОбъект.ДополнительныеСвойства.ПериодОтгрузкиНачало, 
		ЗагружаемыйОбъект.ДополнительныеСвойства.ПериодОтгрузкиКонец);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()
	
	ВыгружаемыеРеквизиты = Новый Массив;
	
	ВыгружаемыеРеквизиты.Добавить("ЗначениеСкидкиНаценки");
	ВыгружаемыеРеквизиты.Добавить("Наименование");
	ВыгружаемыеРеквизиты.Добавить("ПометкаУдаления");
	ВыгружаемыеРеквизиты.Добавить("Предопределенный");
	
	Возврат ВыгружаемыеРеквизиты;
	
КонецФункции

Процедура ДобавитьПроизвольныеРеквизитыКВыгрузке(РеквизитыИСвойства)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоПроект.Проект",
		Новый ОписаниеТипов("СправочникСсылка.Проекты"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоБренд_МТ.Бренд_МТ",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_Бренды_БрендыМТ"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоСКЮ_МТ.СКЮ_МТ",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_СКЮ_СкюМТ"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоБренд_ТМ.Бренд_ТМ",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_Бренды_БрендыТМ"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоВкус.Вкус",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_СКЮ_Вкусы"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоКласс.Класс",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_СКЮ_Классы"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"УсловияПоНоменклатура.Номенклатура",
		Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ЭтоСкидкаЧКН",
		Новый ОписаниеТипов("Булево"));
		
КонецПроцедуры

Процедура ЗаполнитьОтборы(РеквизитыОбъекта, Объект, ПараметрыВыполненияЗапросов, ДанныеСообщения)
	
	Перем адаптер_РаботаСДаннымиИБ;
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ОтборыКомпановкиДанных = ПолучитьДанныеОтбораКомпановкиДанных(Объект);
	Если ОтборыКомпановкиДанных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр(
		"Проекты", 
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоПроект"));
		
	Запрос.УстановитьПараметр(
		"БрендыМТ", 
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоБренд_МТ"));
		
	Запрос.УстановитьПараметр(
		"БрендыТМ",
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоБренд_ТМ"));
		
	Запрос.УстановитьПараметр(
		"СкюМТ", 
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоСКЮ_МТ"));
		
	Запрос.УстановитьПараметр(
		"Классы", 
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоКласс"));
		
	Запрос.УстановитьПараметр(
		"Вкусы",
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоВкус"));
		
	Запрос.УстановитьПараметр(
		"Номенклатура",
		ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, "УсловияПоНоменклатура"));
		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Проекты.Ссылка КАК Проект_ЗначениеРеквизитаИдентификатор,
	|	Проекты.Ссылка КАК Проект_ЗначениеРеквизитаТаблицаКлючей,
	|	Проекты.Код КАК Проект_ЗначениеРеквизитаКод
	|ИЗ
	|	Справочник.Проекты КАК Проекты
	|ГДЕ
	|	Проекты.Ссылка В(&Проекты)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	бг_ЕК_Бренды_БрендыМТ.Ссылка КАК Бренд_МТ_ЗначениеРеквизитаИдентификатор,
	|	бг_ЕК_Бренды_БрендыМТ.Ссылка КАК Бренд_МТ_ЗначениеРеквизитаТаблицаКлючей,
	|	бг_ЕК_Бренды_БрендыМТ.Код КАК Бренд_МТ_ЗначениеРеквизитаКод
	|ИЗ
	|	Справочник.бг_ЕК_Бренды_БрендыМТ КАК бг_ЕК_Бренды_БрендыМТ
	|ГДЕ
	|	бг_ЕК_Бренды_БрендыМТ.Ссылка В(&БрендыМТ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	бг_ЕК_Бренды_БрендыТМ.Ссылка КАК Бренд_ТМ_ЗначениеРеквизитаИдентификатор,
	|	бг_ЕК_Бренды_БрендыТМ.Ссылка КАК Бренд_ТМ_ЗначениеРеквизитаТаблицаКлючей,
	|	бг_ЕК_Бренды_БрендыТМ.Код КАК Бренд_ТМ_ЗначениеРеквизитаКод
	|ИЗ
	|	Справочник.бг_ЕК_Бренды_БрендыТМ КАК бг_ЕК_Бренды_БрендыТМ
	|ГДЕ
	|	бг_ЕК_Бренды_БрендыТМ.Ссылка В(&БрендыТМ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	бг_ЕК_СКЮ_СкюМТ.Ссылка КАК СкюМТ_ЗначениеРеквизитаИдентификатор,
	|	бг_ЕК_СКЮ_СкюМТ.Ссылка КАК СкюМТ_ЗначениеРеквизитаТаблицаКлючей,
	|	бг_ЕК_СКЮ_СкюМТ.Код КАК СкюМТ_ЗначениеРеквизитКод
	|ИЗ
	|	Справочник.бг_ЕК_СКЮ_СкюМТ КАК бг_ЕК_СКЮ_СкюМТ
	|ГДЕ
	|	бг_ЕК_СКЮ_СкюМТ.Ссылка В(&СкюМТ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	бг_ЕК_СКЮ_Классы.Ссылка КАК Класс_ЗначениеРеквизитаИдентификатор,
	|	бг_ЕК_СКЮ_Классы.Ссылка КАК Класс_ЗначениеРеквизитаТаблицаКлючей,
	|	бг_ЕК_СКЮ_Классы.Код КАК Класс_ЗначениеРеквизитаКод
	|ИЗ
	|	Справочник.бг_ЕК_СКЮ_Классы КАК бг_ЕК_СКЮ_Классы
	|ГДЕ
	|	бг_ЕК_СКЮ_Классы.Ссылка В(&Классы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	бг_ЕК_СКЮ_Вкусы.Ссылка КАК Вкус_ЗначениеРеквизитаИдентификатор,
	|	бг_ЕК_СКЮ_Вкусы.Ссылка КАК Вкус_ЗначениеРеквизитаТаблицаКлючей,
	|	бг_ЕК_СКЮ_Вкусы.Код КАК Вкус_ЗначениеРеквизитаКод
	|ИЗ
	|	Справочник.бг_ЕК_СКЮ_Вкусы КАК бг_ЕК_СКЮ_Вкусы
	|ГДЕ
	|	бг_ЕК_СКЮ_Вкусы.Ссылка В(&Вкусы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура_ЗначениеРеквизитаИдентификатор,
	|	Номенклатура.Ссылка КАК Номенклатура_ЗначениеРеквизитаТаблицаКлючей,
	|	Номенклатура.Код КАК Номенклатура_ЗначениеРеквизитаКод
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&Номенклатура)";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Проекты = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
				МассивРезультатов[0],
				ПараметрыВыполненияЗапросов.ТаблицаКлючей,
				ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоПроект", Проекты);
	
	БрендыМТ = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
				МассивРезультатов[1],
				ПараметрыВыполненияЗапросов.ТаблицаКлючей,
				ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоБренд_МТ", БрендыМТ);
	
	БрендыТМ = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
				МассивРезультатов[2],
				ПараметрыВыполненияЗапросов.ТаблицаКлючей,
				ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоБренд_ТМ", БрендыТМ);
	
	СкюМТ = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
				МассивРезультатов[3],
				ПараметрыВыполненияЗапросов.ТаблицаКлючей,
				ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоСКЮ_МТ", СкюМТ);
	
	Классы = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
				МассивРезультатов[4],
				ПараметрыВыполненияЗапросов.ТаблицаКлючей,
				ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоКласс", Классы);
	
	Вкусы = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
				МассивРезультатов[5],
				ПараметрыВыполненияЗапросов.ТаблицаКлючей,
				ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоВкус", Вкусы);
	
	Номенклатура = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
					МассивРезультатов[6],
					ПараметрыВыполненияЗапросов.ТаблицаКлючей,
					ДанныеСообщения);
		
	РеквизитыОбъекта.Вставить("УсловияПоНоменклатура", Номенклатура);
	
КонецПроцедуры

Функция ПолучитьДанныеОтбораКомпановкиДанных(Объект)
	
	СоотстветствиеТипов = ПолучитьСоответствиеТиповДанныхТЧ();
	
	ОтборыКомпановкиДанных = Новый Соответствие;
	
	НастройкиКомпановки = Объект.ХранилищеНастроекКомпоновкиДанных.Получить();
	Если НастройкиКомпановки <> Неопределено 
		И ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(НастройкиКомпановки, "ОтборПоНоменклатуре") Тогда
		
		ЭлементыОтбора = НастройкиКомпановки.ОтборПоНоменклатуре.Отбор.Элементы;
		
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			
			ДанныеОтбора = Новый Структура;
			ЗначениеОтбора = ЭлементОтбора.ПравоеЗначение;
			
			Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
				МассивЭлементовОтбора = ЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения();
			Иначе
				МассивЭлементовОтбора = Новый Массив;
				МассивЭлементовОтбора.Добавить(ЭлементОтбора.ПравоеЗначение);
			КонецЕсли;
			
			ИмяТаблицыОтбора = СоотстветствиеТипов.Получить(ТипЗнч(МассивЭлементовОтбора[0]));
			
			Если ИмяТаблицыОтбора <> Неопределено Тогда
				ДанныеОтбора.Вставить(ИмяТаблицыОтбора, МассивЭлементовОтбора);
				ОтборыКомпановкиДанных.Вставить(ИмяТаблицыОтбора, ДанныеОтбора);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ОтборыКомпановкиДанных;
	
КонецФункции

Функция ПолучитьСоответствиеТиповДанныхТЧ()
	
	СоответствиеТипов = Новый Соответствие;
	
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.Проекты"), "УсловияПоПроект");
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.бг_ЕК_Бренды_БрендыМТ"), "УсловияПоБренд_МТ");
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.бг_ЕК_СКЮ_СкюМТ"), "УсловияПоСКЮ_МТ");
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.бг_ЕК_Бренды_БрендыТМ"), "УсловияПоБренд_ТМ");
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.бг_ЕК_СКЮ_Вкусы"), "УсловияПоВкус");
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.бг_ЕК_СКЮ_Классы"), "УсловияПоКласс");
	СоответствиеТипов.Вставить(Тип("СправочникСсылка.Номенклатура"), "УсловияПоНоменклатура");
	
	Возврат СоответствиеТипов;
	
КонецФункции

Функция ПолучитьДанныеОтбораПоТипу(ОтборыКомпановкиДанных, ИмяТаблицы)
	
	ЭлементыОтбора = Новый Массив;
	
	ДанныеОтбора = ОтборыКомпановкиДанных.Получить(ИмяТаблицы);
	Если ДанныеОтбора <> Неопределено Тогда
		ЭлементыОтбора = ДанныеОтбора[ИмяТаблицы];
	КонецЕсли;
	
	Возврат ЭлементыОтбора;
	
КонецФункции

Процедура ЗаполнитьПризнакСкидкаЧКН(РеквизитыОбъекта, Объект)
	
	Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "Родитель");
	Если Родитель = бг_КонстантыПовтИсп.ЗначениеКонстанты("ГруппаСкидокЧКН") Тогда
		РеквизитыОбъекта.Вставить("ЭтоСкидкаЧКН", Истина);
	Иначе
		РеквизитыОбъекта.Вставить("ЭтоСкидкаЧКН", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучателиСкидок(СтруктураОбъекта)

	ЕстьТерритория = Ложь;
	ЕстьКаналСбыта = Ложь;
	
	ПолучателиСкидок = Новый Массив;
	Если СтруктураОбъекта.Свойство("ПолучателиСкидок") Тогда
		Для каждого СтрокаПолучателиСкидок Из СтруктураОбъекта.ПолучателиСкидок Цикл
			Если СтрокаПолучателиСкидок.Свойство("Контрагент")
				И ЗначениеЗаполнено(СтрокаПолучателиСкидок.Контрагент) Тогда
				ПолучателиСкидок.Добавить(СтрокаПолучателиСкидок.Контрагент);
			КонецЕсли;
			Если СтрокаПолучателиСкидок.Свойство("Территория")
				И ЗначениеЗаполнено(СтрокаПолучателиСкидок.Территория) Тогда
				ПолучателиСкидок.Добавить(СтрокаПолучателиСкидок.Территория);
				ЕстьТерритория = Истина;
			КонецЕсли;
			Если СтрокаПолучателиСкидок.Свойство("КаналСбыта")
				И ЗначениеЗаполнено(СтрокаПолучателиСкидок.КаналСбыта) Тогда
				ПолучателиСкидок.Добавить(СтрокаПолучателиСкидок.КаналСбыта);
				ЕстьКаналСбыта = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЕстьТерритория = Ложь
		И СтруктураОбъекта.Свойство("Территория") Тогда
		ПолучателиСкидок.Добавить(СтруктураОбъекта.Территория);
	КонецЕсли;
	Если ЕстьКаналСбыта = Ложь
		И СтруктураОбъекта.Свойство("КаналПродаж") Тогда
		ПолучателиСкидок.Добавить(СтруктураОбъекта.КаналПродаж);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПолучателиСкидок) Тогда
		Возврат ПолучателиСкидок;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка В(&ПолучателиСкидок)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КаналыПродаж.Ссылка
	|ИЗ
	|	Справочник.битКаналыПродаж КАК КаналыПродаж
	|ГДЕ
	|	КаналыПродаж.Ссылка В(&ПолучателиСкидок)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ТерриторииПунктовНазначения.Ссылка
	|ИЗ
	|	Справочник.битТерриторииПунктовНазначения КАК ТерриторииПунктовНазначения
	|ГДЕ
	|	ТерриторииПунктовНазначения.Ссылка В(&ПолучателиСкидок)";
	
	Запрос.УстановитьПараметр("ПолучателиСкидок", ПолучателиСкидок);
	
	ПолучателиСкидок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");;
	
	Возврат ПолучателиСкидок;

КонецФункции

Процедура ЗаполнитьЦеновыеГруппы(ЗагружаемыйОбъект, СтруктураОбъекта)

	Если Не СтруктураОбъекта.Свойство("РасшифровкаБрендов") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаРасшифровкаБрендов Из СтруктураОбъекта.РасшифровкаБрендов Цикл
		ЗаполненБренд = ЗначениеЗаполнено(СтрокаРасшифровкаБрендов.Бренд);
		
		Если ЗаполненБренд
			Или ЗначениеЗаполнено(СтрокаРасшифровкаБрендов.СКЮ_МТ) Тогда
			СтрокаЦеноваяГруппа = ЗагружаемыйОбъект.бг_ЦеновыеГруппы.Добавить();
			СтрокаЦеноваяГруппа.ЗначениеСкидкиНаценки = СтрокаРасшифровкаБрендов.ПроцентСкидкиНаценки;
			Если ЗаполненБренд Тогда
				ЗагружаемыйОбъект.бг_ИсточникЦеновойГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Смешанный;
			КонецЕсли;
			
			Если ЗагружаемыйОбъект.бг_ИсточникЦеновойГруппы = Перечисления.бг_ИсточникиЦеновойГруппы.Смешанный Тогда
				СтрокаЦеноваяГруппа.ЦеноваяГруппа = СтрокаРасшифровкаБрендов.Бренд;
				СтрокаЦеноваяГруппа.Бренд_МТ = СтрокаРасшифровкаБрендов.БрендМТ;
				СтрокаЦеноваяГруппа.Вкус = СтрокаРасшифровкаБрендов.ВкусМТ;
				СтрокаЦеноваяГруппа.СкюМТ = СтрокаРасшифровкаБрендов.СКЮ_МТ;
			Иначе
				СтрокаЦеноваяГруппа.ЦеноваяГруппа = СтрокаРасшифровкаБрендов.СКЮ_МТ;
			КонецЕсли;
			
		Иначе
			ЗагружаемыйОбъект.ЗначениеСкидкиНаценки = СтрокаРасшифровкаБрендов.ПроцентСкидкиНаценки;
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры


Процедура ЗаписатьДействиеСкидок(СкидкаНаценка, Знач ИсточникиДействияСкидок, 
	ДатаНачалаДействияСхемы = Неопределено, ДатаОкончанияДействияСхемы = Неопределено)

	Если Не ЗначениеЗаполнено(ИсточникиДействияСкидок) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ИсточникиДействияСкидок) <> Тип("Массив") Тогда
		ИсточникиДействияСкидокКопия = ИсточникиДействияСкидок;
		ИсточникиДействияСкидок = Новый Массив;
		ИсточникиДействияСкидок.Добавить(ИсточникиДействияСкидокКопия);
	КонецЕсли;
	
	Для каждого Источник Из ИсточникиДействияСкидок Цикл
		НаборЗаписей = РегистрыСведений.ДействиеСкидокНаценок.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Источник.Установить(Источник);
		НаборЗаписей.Отбор.СкидкаНаценка.Установить(СкидкаНаценка);
		Если ЗначениеЗаполнено(ДатаНачалаДействияСхемы) Тогда

			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Период = ДатаНачалаДействияСхемы;
			НоваяЗапись.Источник = Источник;
			НоваяЗапись.СкидкаНаценка = СкидкаНаценка;
			
			НоваяЗапись.Статус = Перечисления.СтатусыДействияСкидок.Действует;
			НоваяЗапись.Ответственный = Пользователи.ТекущийПользователь();
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаОкончанияДействияСхемы) Тогда
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Период = ДатаОкончанияДействияСхемы;
			НоваяЗапись.Источник = Источник;
			НоваяЗапись.СкидкаНаценка = СкидкаНаценка;
			
			НоваяЗапись.Статус = Перечисления.СтатусыДействияСкидок.НеДействует;
			НоваяЗапись.Ответственный = Пользователи.ТекущийПользователь();
			
		КонецЕсли;
		
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти