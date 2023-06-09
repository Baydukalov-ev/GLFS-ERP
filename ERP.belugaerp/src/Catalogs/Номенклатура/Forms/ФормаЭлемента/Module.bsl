#Область ОбработчикиСобытий

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьПолеТипМарки();
	бг_ДобавитьПоляНСИ();
	бг_ДобавитьПоляB2B();
	бг_ДобавитьПоляSAP();
	бг_ДобавитьПоляКонтрольКачества();
	бг_ДобавитьПоляЧастейНаименования();   
	бг_ДобавитьГиперссылкуШтрихкодыЕКНоменклатуры();
	бг_ДобавитьПолеСтатьяКалькуляции();
	бг_ДобавитьПоляПараметровУчета();
	
	бг_ДобавитьРеквизитыПоляПиктограмма();
	бг_ОбновитьАдресПиктограммы();
	бг_ДобавитьПоляДляОпределенияИмпортныхССП();

	бг_ДобавитьКомандуВыгрузить();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
		
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И бг_ЕстьОшибкиЗаполненияШтрихкодовУпаковок(Объект.Ссылка) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Для упаковок номенклатуры нет штрихкодов.
			|Упаковки номенклатуры не будут корректно выгружены в Solvo'"));	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ПередЗаписьюНаСервереПеред(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если бг_КонстантыПовтИсп.ЗначениеКонстанты("ЗапретитьИнтерактивноеИзменениеНоменклатурыИУпаковок") Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Временно установлен запрет на редактирование'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ПослеЗаписиНаСервереПеред(ТекущийОбъект, ПараметрыЗаписи) 
	
	бг_СкопироватьПодчиненныеУпаковки();   
	ПараметрЗаполнения = ПараметрыКопированияДополнительныхДанных.НайтиПоЗначению("бг_СоздатьБазовыеУпаковки");
	Если ПараметрЗаполнения <> Неопределено
		И ПараметрЗаполнения.Пометка Тогда
		бг_СоздатьБазовыеУпаковки();
	КонецЕсли;
																	
КонецПроцедуры

&НаСервере
Процедура бг_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)

	бг_СоздатьШтучнуюУпаковку();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура бг_АдресКартинкиПиктограммаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	ПараметрыОповещения = Новый Структура("ВыборИзображения, ВыборФайлаОписания", Истина, Ложь);
	ОписаниеОповещения  = Новый ОписаниеОповещения("бг_ДобавлениеПиктограммыЗавершение",
													ЭтотОбъект,
													ПараметрыОповещения);
	
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка,
										УникальныйИдентификатор,
										НоменклатураКлиент.ФильтрФайловИзображений(),
										,
										ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура бг_КрепостьПриИзмененииПосле(Элемент)
	
	бг_ЗаполнитьНаименованиеИзЧастейНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварнаяКатегорияПриИзмененииПосле(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ТоварнаяКатегория) Тогда
		Емкость = бг_ЕмкостьПоТоварнойКатегории(Объект.ТоварнаяКатегория); 
		Если ЗначениеЗаполнено(Емкость) Тогда
			КоличествоЛитровВДале = 10;
			Объект.ОбъемДАЛ = Емкость / КоличествоЛитровВДале;
		    бг_РассчитатьКоэффициентЕдиницыДляОтчетов();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Процедура бг_ОбъемДАЛПриИзмененииПосле(Элемент) 
	
	бг_РассчитатьКоэффициентЕдиницыДляОтчетов();
	
КонецПроцедуры  

&НаКлиенте
Процедура бг_ЕдиницаДляОтчетовПриИзмененииПосле(Элемент)
	
	бг_РассчитатьКоэффициентЕдиницыДляОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ШтрихкодыЕКНоменклатурыНажатие(Элемент)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(, НСтр("ru='Штрихкоды ЕК номенклатуры доступны только после записи элемента'")); 
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.бг_Штрихкоды_ЕК_Номенклатуры.ФормаСписка",
		Новый Структура("Отбор",
			Новый Структура("Номенклатура", Объект.Ссылка)),
		,
		Истина,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&После("НастроитьФормуИОбновитьКарточку")
&НаСервере
Процедура бг_НастроитьФормуИОбновитьКарточку()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ТипМарки", "Видимость", 
		Объект.ВидНоменклатуры = бг_КонстантыПовтИсп.ЗначениеКонстанты("ФедеральнаяСпецМарка"));
		
	ЭтоИмпортныеССП = ЭтаФорма.бг_ИмпортныеССП = Объект.ВидНоменклатуры;
	Элементы.бг_ТипИмпортныхССП.Видимость = ЭтоИмпортныеССП;
	
	бг_СкрытьНеиспользуемыеРеквизиты();
	бг_УстановитьВидимостьПолейНСИ();
	бг_УстановитьВидимостьПолейЧастейНаименования();
	бг_УстановитьБлокировкуПолейНСИ();
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПолеТипМарки()
	
	КонтекстПоля = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, Элементы.СворачиваемаяГруппаАлкоголь, Элементы.ВидАлкогольнойПродукции);	
	КонтекстПоля.Свойства.Вставить("ПутьКДанным", "Объект.бг_ТипМарки");
	бг_ПрограммныйИнтерфейс.НовоеПолеФормы(КонтекстПоля, "ТипМарки");
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляКонтрольКачества()
	бг_АнализыДляУдостоверенияОКачестве = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_АнализыДляУдостоверенияОКачестве",
		Элементы.СворачиваемаяГруппаАлкоголь,
		"Объект.бг_АнализыДляУдостоверенияОКачестве");
		
	бг_НормативныйДокумент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_НормативныйДокумент",
		Элементы.СворачиваемаяГруппаАлкоголь,
		"Объект.бг_НормативныйДокумент");
		
	бг_ОписаниеСоставаПродукта = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ОписаниеСоставаПродукта",
		Элементы.СворачиваемаяГруппаАлкоголь,
		"Объект.бг_ОписаниеСоставаПродукта");
	бг_ОписаниеСоставаПродукта.МногострочныйРежим = Истина;
	бг_ОписаниеСоставаПродукта.Высота = 2;
	бг_ОписаниеСоставаПродукта.РастягиватьПоВертикали = Ложь;
		
	бг_УсловияТранспортирования = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_УсловияТранспортирования",
		Элементы.СворачиваемаяГруппаАлкоголь,
		"Объект.бг_УсловияТранспортирования");
	бг_УсловияТранспортирования.МногострочныйРежим = Истина;
	бг_УсловияТранспортирования.Высота = 2;
	бг_УсловияТранспортирования.РастягиватьПоВертикали = Ложь;
	
	бг_СрокХраненияПробВЛабораторииМесяцев = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_СрокХраненияПробВЛабораторииМесяцев",
		Элементы.СворачиваемаяГруппаАлкоголь,
		"Объект.бг_СрокХраненияПробВЛабораторииМесяцев");
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьРеквизитыПоляПиктограмма()
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(
		Новый РеквизитФормы(
			"бг_АдресКартинкиПиктограмма",
			ОбщегоНазначения.ОписаниеТипаСтрока(0), ,
			НСтр("ru = 'Пиктограмма'")));
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	бг_ЭлементПиктограмма = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Пиктограмма",
		Элементы.СворачиваемаяГруппаАлкоголь,
		"бг_АдресКартинкиПиктограмма",
		,
		,
		"ПолеКартинки");
	бг_ЭлементПиктограмма.Гиперссылка = Истина;
	бг_ЭлементПиктограмма.ТекстНевыбраннойКартинки = НСтр("ru = 'Добавить пиктограмму'");
	бг_ЭлементПиктограмма.Ширина = 15;
	бг_ЭлементПиктограмма.Высота = 4;
	бг_ЭлементПиктограмма.РастягиватьПоВертикали = Ложь;
	бг_ЭлементПиктограмма.РастягиватьПоГоризонтали = Ложь;
	бг_ЭлементПиктограмма.РазмерКартинки = РазмерКартинки.АвтоРазмер;
	
	бг_ЭлементПиктограмма.УстановитьДействие("Нажатие", "бг_АдресКартинкиПиктограммаНажатие");
КонецПроцедуры

&НаКлиенте
Процедура бг_ДобавлениеПиктограммыЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	СсылкаНаФайл = ВыбранныеФайлы[0];
	Объект.бг_ФайлПиктограммы = СсылкаНаФайл;
	бг_ОбновитьАдресПиктограммы();
	
КонецПроцедуры

&НаСервере
Процедура бг_ОбновитьАдресПиктограммы()
	
	Если Объект.бг_ФайлПиктограммы.Пустая() Тогда
		ЭтотОбъект.бг_АдресКартинкиПиктограмма = "";
	Иначе
		
		УстановитьПривилегированныйРежим(Истина);
		Попытка
			ЭтотОбъект.бг_АдресКартинкиПиктограмма = РаботаСФайлами.ДанныеФайла(Объект.бг_ФайлПиктограммы, УникальныйИдентификатор).СсылкаНаДвоичныеДанныеФайла;;
		Исключение
			ЭтотОбъект.бг_АдресКартинкиПиктограмма = "";
		КонецПопытки;
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляДляОпределенияИмпортныхССП()
	
	бг_ТипИмпортныхССП = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ТипИмпортныхССП",
		Элементы.СворачиваемаяГруппаОсновныеПараметрыУчета,
		"Объект.бг_ТипИмпортныхССП",,
		Элементы.ГруппаТипНоменклатурыНабора,
		"ПолеПереключателя");
	бг_ТипИмпортныхССП.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.бг_ТипыИмпортныхССП.Ароматизитор"));
	бг_ТипИмпортныхССП.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.бг_ТипыИмпортныхССП.Дистиллят"));
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(
		Новый РеквизитФормы(
			"бг_ИмпортныеССП",
			Новый ОписаниеТипов("СправочникСсылка.ВидыНоменклатуры")));
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	ЭтаФорма.бг_ИмпортныеССП = бг_КонстантыПовтИсп.ЗначениеКонстанты("ИмпортныеССП");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_Пользователи_РолиДоступны(ИменаРолей)
	
	Возврат Пользователи.РолиДоступны(ИменаРолей);
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьПоляНСИ()
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ЕК_СУМ",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ЕК_СУМ");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Статус",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Статус");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Добавлен",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Добавлен");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Выбыл",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Выбыл");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ГодУрожая",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ГодУрожая");
	
	Элемент.УстановитьДействие("ПриИзменении", "бг_ГодУрожаяПриИзменении");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ТемператураОт",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ТемператураОт");
	Элемент.УстановитьДействие("ПриИзменении", "бг_ТемператураОтПриИзменении");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ТемператураДо",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ТемператураДо");
	Элемент.УстановитьДействие("ПриИзменении", "бг_ТемператураДоПриИзменении");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Влажность",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Влажность");
	Элемент.УстановитьДействие("ПриИзменении", "бг_ВлажностьПриИзменении");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ТемператураХранения",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ТемператураХранения");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	Элемент.МаксимальнаяШирина = 28;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КонтрагентПроизводитель",
		Элементы.СворачиваемаяГруппаСведенияОПроизводителе,
		"Объект.бг_КонтрагентПроизводитель",
		, // ТипЭлемента
		ЭтотОбъект.Элементы.ПроизводительИмпортерКонтрагент);
		
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ОсновнойПоставщик",
		Элементы.СворачиваемаяГруппаСведенияОПроизводителе,
		"Объект.бг_ОсновнойПоставщик");
		
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Производитель",
		Элементы.СворачиваемаяГруппаСведенияОПроизводителе,
		"Объект.ТоварнаяКатегория.бг_Бренд.Производитель");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Марка",
		Элементы.СворачиваемаяГруппаСведенияОПроизводителе,
		"Объект.ТоварнаяКатегория.бг_Бренд");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Предшественник",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Предшественник");
	Элемент.ТолькоПросмотр = Истина;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Проверен",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Проверен",
		, // ТипЭлемента
		, // Элемент
		"ПолеФлажка");
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_СрокГодности",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_СрокГодности");
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляB2B()
	
	бг_ОбменB2B = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ОбменB2B",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ОбменB2B",
		, // ТипЭлемента
		, // Элемент
		"ПолеФлажка");
	бг_ОбменB2B.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляSAP()
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодНоменклатурыSAP",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_КодНоменклатурыSAP");
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляПараметровУчета()

	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_УчетОстатковИРезервовВРазрезеУпаковокПаллет",
		Элементы.СворачиваемаяГруппаОсновныеПараметрыУчета,
		"Объект.бг_УчетОстатковИРезервовВРазрезеУпаковокПаллет",,,
		"ПолеФлажка");
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
    Элемент.ТолькоПросмотр = Истина; // Строго берется из вида номенклатуры.
	
КонецПроцедуры
	
&НаСервере
Процедура бг_СкрытьНеиспользуемыеРеквизиты()
	
	Элементы.Производитель.Видимость = Ложь;
	Элементы.Марка.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьПолейНСИ()
	
	Если ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(
		Объект.ВидНоменклатуры,
		"бг_ОграничиватьДобавлениеИзменениеНоменклатуры") = Истина Тогда
		ВидимостьРеквизитов = Истина;
	Иначе
		ВидимостьРеквизитов = Ложь;
	КонецЕсли;
	
	Элементы.бг_Статус.Видимость = ВидимостьРеквизитов;
	Элементы.бг_Добавлен.Видимость = ВидимостьРеквизитов;
	Элементы.бг_Выбыл.Видимость = ВидимостьРеквизитов;
	Элементы.бг_ГодУрожая.Видимость = ВидимостьРеквизитов;
	Элементы.бг_ТемператураХранения.Видимость = ВидимостьРеквизитов;
	Элементы.бг_Предшественник.Видимость = ВидимостьРеквизитов;
	Элементы.бг_Проверен.Видимость = ВидимостьРеквизитов;
	Элементы.бг_ТемператураОт.Видимость = ВидимостьРеквизитов;
	Элементы.бг_ТемператураДо.Видимость = ВидимостьРеквизитов;
	Элементы.бг_Влажность.Видимость = ВидимостьРеквизитов;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляЧастейНаименования()
	
	бг_ГруппаЧастиНаименования = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
		ЭтотОбъект,
		"бг_ГруппаЧастиНаименования",
		Элементы.СтраницаУдалитьПослеВыключенияСовместимости,
		, // ВидГруппы
		Элементы.ГруппаНаименованиеИКоманды);
	
	бг_ГруппаЧастиНаименования.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	бг_ГруппаЧастиНаименования.ОтображатьЗаголовок = Ложь;
	бг_ГруппаЧастиНаименования.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	бг_ОсновноеНаименование = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ОсновноеНаименование",
		Элементы.бг_ГруппаЧастиНаименования,
		"Объект.бг_ОсновноеНаименование");
	
	бг_ОсновноеНаименование.УстановитьДействие("ПриИзменении", "бг_ОсновноеНаименованиеПриИзменении");
	
	бг_Вариативность = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Вариативность",
		Элементы.бг_ГруппаЧастиНаименования,
		"Объект.бг_Вариативность");
	
	бг_Вариативность.УстановитьДействие("ПриИзменении", "бг_ВариативностьПриИзменении");
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьПолейЧастейНаименования()
	
	Если ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(
		Объект.ВидНоменклатуры,
		"бг_ОграничиватьДобавлениеИзменениеНоменклатуры") = Истина Тогда
		ИспользоватьЧастиНаименования = Истина;
	Иначе
		ИспользоватьЧастиНаименования = Ложь;
	КонецЕсли;
	
	Элементы.бг_ОсновноеНаименование.Видимость = ИспользоватьЧастиНаименования;
	Элементы.бг_Вариативность.Видимость = ИспользоватьЧастиНаименования;
	Элементы.Наименование.ТолькоПросмотр = ИспользоватьЧастиНаименования;
	Элементы.ЗаполнитьРабочееНаименованиеПоШаблону.Доступность = Не ИспользоватьЧастиНаименования;
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОсновноеНаименованиеПриИзменении()
	
	бг_ЗаполнитьНаименованиеИзЧастейНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ВариативностьПриИзменении()
	
	бг_ЗаполнитьНаименованиеИзЧастейНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ГодУрожаяПриИзменении()
	
	бг_ЗаполнитьНаименованиеИзЧастейНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗаполнитьНаименованиеИзЧастейНаКлиенте()
	
	Если ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(
		Объект.ВидНоменклатуры,
		"бг_ОграничиватьДобавлениеИзменениеНоменклатуры") = Истина Тогда
		
		ЧастиНаименования = бг_ЧастиНаименования();
		
		ЗначенияЧастей = Новый Структура;
		
		Для Каждого ЧастьНаименования Из ЧастиНаименования Цикл
			ЗначенияЧастей.Вставить(ЧастьНаименования, Объект[ЧастьНаименования]);
		КонецЦикла;
		
		Объект.Наименование = бг_НаименованиеИзЧастейНаСервере(ЗначенияЧастей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_ЧастиНаименования()
	
	Возврат Справочники.Номенклатура.бг_ЧастиНаименования();
	
КонецФункции

&НаСервереБезКонтекста
Функция бг_НаименованиеИзЧастейНаСервере(ЗначенияЧастей)
	
	Возврат Справочники.Номенклатура.бг_НаименованиеИзЧастей(ЗначенияЧастей);
	
КонецФункции

&НаСервере
Процедура бг_УстановитьБлокировкуПолейНСИ()
	
	Если ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(
		Объект.ВидНоменклатуры,
		"бг_ОграничиватьДобавлениеИзменениеНоменклатуры") = Истина Тогда
		бг_ОграничиватьДобавлениеИзменениеНоменклатуры = Истина;
		Роль_Администратор = Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНоменклатурыАдминистратор");
		Роль_Администратор_Пользователь = Пользователи.РолиДоступны(
			"бг_ДобавлениеИзменениеНоменклатурыАдминистратор, 
			|бг_ДобавлениеИзменениеНоменклатурыОтветственныйПользователь");
		Роль_Администратор_Пользователь_Оператор = Пользователи.РолиДоступны(
			"бг_ДобавлениеИзменениеНоменклатурыАдминистратор, 
			|бг_ДобавлениеИзменениеНоменклатурыОтветственныйПользователь, 
			|бг_ДобавлениеИзменениеНоменклатурыОператорПриемки");
		Роль_Администратор_Пользователь_Оператор_РуководительВыписки = Пользователи.РолиДоступны(
			"бг_ДобавлениеИзменениеНоменклатурыАдминистратор, 
			|бг_ДобавлениеИзменениеНоменклатурыОтветственныйПользователь, 
			|бг_ДобавлениеИзменениеНоменклатурыОператорПриемки, 
			|бг_ДобавлениеИзменениеНоменклатурыРегиональныйРуководительОтделаВыписки");
		Роль_Пользователь = Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНоменклатурыОтветственныйПользователь"); 
		Роль_Оператор = Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНоменклатурыОператорПриемки"); 
		Роль_РуководительВыписки = Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНоменклатурыРегиональныйРуководительОтделаВыписки"); 
	Иначе
		бг_ОграничиватьДобавлениеИзменениеНоменклатуры = Ложь;
		Роль_Администратор = Истина;
		Роль_Администратор_Пользователь = Истина;
		Роль_Администратор_Пользователь_Оператор = Истина;
		Роль_Администратор_Пользователь_Оператор_РуководительВыписки = Истина;  
		Роль_Пользователь = Истина;
		Роль_Оператор = Истина;
		Роль_РуководительВыписки = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.бг_Предшественник) Тогда
		Элементы.Артикул.ТолькоПросмотр = Не Роль_Администратор_Пользователь_Оператор;
		Элементы.бг_ОбменB2B.ТолькоПросмотр = Не Роль_Администратор_Пользователь_Оператор;
		Элементы.ВидНоменклатуры.ТолькоПросмотр = бг_ОграничиватьДобавлениеИзменениеНоменклатуры;
		Элементы.СтавкаНДС.ТолькоПросмотр = бг_ОграничиватьДобавлениеИзменениеНоменклатуры;
	Иначе
		Элементы.Артикул.ТолькоПросмотр = Не Роль_Администратор_Пользователь;
		Элементы.бг_ОбменB2B.ТолькоПросмотр = Не Роль_Администратор_Пользователь;
		Элементы.ВидНоменклатуры.ТолькоПросмотр = Не Роль_Администратор_Пользователь;
		Элементы.СтавкаНДС.ТолькоПросмотр = Не Роль_Администратор_Пользователь;
	КонецЕсли;
	
	Элементы.Наименование.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь;
	Элементы.НаименованиеПолное.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.бг_ОсновноеНаименование.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь;
		
	Элементы.бг_Вариативность.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.бг_КонтрагентПроизводитель.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.ПроизводительИмпортерКонтрагент.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.бг_Статус.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь; 
		
	Элементы.бг_Добавлен.ТолькоПросмотр 
		= Не Роль_Администратор;
	Элементы.бг_Выбыл.ТолькоПросмотр 
		= Не Роль_Администратор;
	Элементы.бг_ГодУрожая.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.бг_ТемператураХранения.ТолькоПросмотр = Истина;
	Элементы.бг_Проверен.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь;
		
	Элементы.ТоварнаяКатегория.ТолькоПросмотр 
		= Не Роль_Администратор;
	Элементы.ИспользоватьУпаковки.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь;
	Элементы.ЕдиницаИзмерения.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.ЕдиницаДляОтчетов.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь И Не Роль_Оператор;
	Элементы.ВесЕдиницаИзмерения.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.ОбъемЕдиницаИзмерения.ТолькоПросмотр 
		= бг_ОграничиватьДобавлениеИзменениеНоменклатуры; 
		
	Элементы.ДлинаЕдиницаИзмерения.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.ВидАлкогольнойПродукции.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.ИмпортнаяАлкогольнаяПродукция.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.ОбъемДАЛ.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор;  
		
	Элементы.Крепость.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки; 
	Элементы.бг_Предшественник.ТолькоПросмотр 
		= Не Роль_Администратор;
		
	Элементы.бг_ТемператураОт.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.бг_ТемператураДо.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	Элементы.бг_Влажность.ТолькоПросмотр 
		= Не Роль_Администратор_Пользователь_Оператор_РуководительВыписки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_ЕмкостьПоТоварнойКатегории(ТоварнаяКатегория)   
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТоварнаяКатегория, "бг_Объем.Емкость");  
	
КонецФункции   

&НаКлиенте
Процедура бг_РассчитатьКоэффициентЕдиницыДляОтчетов() 
	
	Если Не ЗначениеЗаполнено(Объект.ТоварнаяКатегория) 
		Или Объект.ЕдиницаДляОтчетов = Объект.ЕдиницаИзмерения Тогда
		Объект.КоэффициентЕдиницыДляОтчетов = 1;   
		Возврат;
	КонецЕсли; 
	
	Если Не бг_ЭтоДекалитр(Объект.ЕдиницаДляОтчетов) Тогда
		Возврат;
	КонецЕсли;
	
	Емкость = бг_ЕмкостьПоТоварнойКатегории(Объект.ТоварнаяКатегория);
	Если ЗначениеЗаполнено(Емкость) Тогда
		КоличествоЛитровВОдномДале = 10;
		Объект.КоэффициентЕдиницыДляОтчетов = КоличествоЛитровВОдномДале / Емкость;
	Иначе
		Объект.КоэффициентЕдиницыДляОтчетов = 1;
	КонецЕсли; 
	
КонецПроцедуры    

&НаСервереБезКонтекста
Функция бг_ЭтоДекалитр(ЕдиницаИзмерения)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдиницаИзмерения, "бг_ТипЕдиницыИзмерения")
	 = Перечисления.бг_ТипыЕдиницИзмерения.Дал;
	
КонецФункции

&НаСервере
Процедура бг_СкопироватьПодчиненныеУпаковки() 
	
	СоответствиеСкопированныхДанных = Новый Соответствие;
	
	Если ТипЗнч(ПараметрыКопированияДополнительныхДанных) = Тип("СписокЗначений") Тогда
		Для каждого ПараметрКопирования Из ПараметрыКопированияДополнительныхДанных Цикл
			
			Если ПараметрКопирования.Пометка 
				И ТипЗнч(ПараметрКопирования.Значение) = Тип("СправочникСсылка.УпаковкиЕдиницыИзмерения") Тогда 
				НовыйВладелец = Объект.Ссылка;
				ЗначенияРеквизитовУпаковки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрКопирования.Значение,
					"Родитель, Родитель.Родитель, ЕдиницаИзмерения.бг_ТипЕдиницыИзмерения");
				Если ЗначенияРеквизитовУпаковки.ЕдиницаИзмерениябг_ТипЕдиницыИзмерения
					= Перечисления.бг_ТипыЕдиницИзмерения.Паллета Тогда
					
					УпаковкаБутылка = ЗначенияРеквизитовУпаковки.РодительРодитель;
					УпаковкаКоробка = ЗначенияРеквизитовУпаковки.Родитель;
					УпаковкаПаллета = ПараметрКопирования.Значение;
					
				Иначе
					
					УпаковкаБутылка = ЗначенияРеквизитовУпаковки.Родитель;
					УпаковкаКоробка = ПараметрКопирования.Значение;
					УпаковкаПаллета = Неопределено;
					
				КонецЕсли;
				
				УпаковкаБутылкаСкопированная = СоответствиеСкопированныхДанных.Получить(УпаковкаБутылка);
				Если УпаковкаБутылкаСкопированная = Неопределено Тогда
					УпаковкаБутылкаСкопированная = бг_СкопироватьУпаковку(НовыйВладелец, УпаковкаБутылка, Неопределено);
				КонецЕсли;
				УпаковкаКоробкаСкопированная = бг_СкопироватьУпаковку(НовыйВладелец, УпаковкаКоробка, УпаковкаБутылкаСкопированная);
				
				СоответствиеСкопированныхДанных.Вставить(УпаковкаБутылка, УпаковкаБутылкаСкопированная);
				СоответствиеСкопированныхДанных.Вставить(УпаковкаКоробка, УпаковкаКоробкаСкопированная);
				
				Если ЗначениеЗаполнено(УпаковкаПаллета) Тогда
					УпаковаПаллетаСкопированная = бг_СкопироватьУпаковку(НовыйВладелец, УпаковкаПаллета, УпаковкаКоробкаСкопированная);
					СоответствиеСкопированныхДанных.Вставить(УпаковкаПаллета, УпаковаПаллетаСкопированная);
				КонецЕсли; 
					
			КонецЕсли;  
			
			Если ПараметрКопирования.Пометка 
				И ТипЗнч(ПараметрКопирования.Значение) = Тип("СправочникСсылка.бг_Штрихкоды_ЕК_Номенклатуры") Тогда 
				
				НовыйВладелец = СоответствиеСкопированныхДанных.Получить(
					ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрКопирования.Значение, "Владелец"));
					
				бг_СкопироватьШтрихкодЕКНоменклатуры(НовыйВладелец, ПараметрКопирования.Значение);
			КонецЕсли;  
			
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры 

&НаСервереБезКонтекста
Функция бг_СкопироватьУпаковку(НовыйВладелец, ИсходнаяУпаковка, Родитель)   
	
	УпаковкаОбъект = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(УпаковкаОбъект, ИсходнаяУпаковка, , "Родитель, Владелец, Код,"
		+ "бг_КодЕК_Номенклатуры, бг_ИдентификаторЕКНоменклатуры, бг_Проверен");
	УпаковкаОбъект.Родитель = Родитель;
	УпаковкаОбъект.Владелец = НовыйВладелец;
	УпаковкаОбъект.Записать();
	
	Возврат УпаковкаОбъект.Ссылка;
	
КонецФункции  

&НаСервереБезКонтекста
Функция бг_СкопироватьШтрихкодЕКНоменклатуры(НовыйВладелец, ИсходныйШтрихкод)
	
	ШтрихкодОбъект = Справочники.бг_Штрихкоды_ЕК_Номенклатуры.СоздатьЭлемент();
	РеквизитыШтрихкода = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ИсходныйШтрихкод, 
		"Штрихкод, ЕдиницаИзмерения");
	ШтрихкодОбъект.Штрихкод = РеквизитыШтрихкода.Штрихкод;
	ШтрихкодОбъект.ЕдиницаИзмерения = РеквизитыШтрихкода.ЕдиницаИзмерения;
	ШтрихкодОбъект.Владелец = НовыйВладелец; 
	ШтрихкодОбъект.УстановитьНовыйКод();
	ШтрихкодОбъект.Записать();
	
	Возврат ШтрихкодОбъект.Ссылка;
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьГиперссылкуШтрихкодыЕКНоменклатуры()
	
	бг_ГиперссылкаШтрихкодыЕКНоменклатуры = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьДекорациюНаФорму(
		ЭтотОбъект,
		"бг_ГиперссылкаШтрихкодыЕКНоменклатуры",
		Элементы.АртикулКодШтрихкод,
		"Штрихкоды ЕК номенклатуры",
		ВидДекорацииФормы.Надпись);
	бг_ГиперссылкаШтрихкодыЕКНоменклатуры.Гиперссылка = Истина;
	бг_ГиперссылкаШтрихкодыЕКНоменклатуры.УстановитьДействие("Нажатие", "бг_ШтрихкодыЕКНоменклатурыНажатие");
	
КонецПроцедуры

&НаСервере
&После("ПодготовитьДанныеДляИнтерактиваПередЗаписью")
Процедура бг_ПодготовитьДанныеДляИнтерактиваПередЗаписью(Отказ)
	
	Если Не Отказ
		И Не (ПараметрыСоздания().Свойство("ИсточникКопирования")
			И ЗначениеЗаполнено(ПараметрыСоздания().ИсточникКопирования))
		И Не НастройкиКопированияЗаданы 
		И Объект.Ссылка.Пустая() 
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ВидНоменклатуры, 
			"бг_ОграничиватьДобавлениеИзменениеНоменклатуры") = Истина Тогда
	
		ПараметрыКопированияДополнительныхДанных.Добавить("бг_СоздатьБазовыеУпаковки",
			НСтр("ru = 'Создать базовые упаковки'"),
			Истина); 
		
	КонецЕсли;  
		
КонецПроцедуры  

&НаСервере
Процедура бг_СоздатьБазовыеУпаковки()    
	
	УстановитьПривилегированныйРежим(Истина);
	УпаковкаБутылка = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
	УпаковкаБутылка.Наименование = Строка(Объект.ЕдиницаИзмерения);
	УпаковкаБутылка.ЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
	УпаковкаБутылка.Владелец = Объект.Ссылка;
	УпаковкаБутылка.Числитель = 1;
	УпаковкаБутылка.Знаменатель = 1; 
	УпаковкаБутылка.ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина);  
	УпаковкаБутылка.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Упаковка;
	УпаковкаБутылка.Записать();
	
	УпаковкаКоробка = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент(); 
	ЕдиницаПоКлассификатору = бг_ЕдиницаПоКлассфикаторуПоТипу(Перечисления.бг_ТипыЕдиницИзмерения.Коробка);
	УпаковкаКоробка.Наименование = СтрШаблон(НСтр("ru='%1 (N %2)'"), Строка(ЕдиницаПоКлассификатору), УпаковкаБутылка.Наименование);
	УпаковкаКоробка.ЕдиницаИзмерения = ЕдиницаПоКлассификатору;
	УпаковкаКоробка.Владелец = Объект.Ссылка;
	УпаковкаКоробка.Числитель = 1;
	УпаковкаКоробка.Знаменатель = 1;  
	УпаковкаКоробка.Родитель = УпаковкаБутылка.Ссылка;  
	УпаковкаКоробка.ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина); 
	УпаковкаКоробка.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Упаковка;
	УпаковкаКоробка.Записать();
	
	УпаковкаПаллета = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент(); 
	ЕдиницаПоКлассификатору = бг_ЕдиницаПоКлассфикаторуПоТипу(Перечисления.бг_ТипыЕдиницИзмерения.Паллета);
	УпаковкаПаллета.Наименование = СтрШаблон(НСтр("ru='%1 (N %2)'"), Строка(ЕдиницаПоКлассификатору), УпаковкаКоробка.Наименование);
	УпаковкаПаллета.ЕдиницаИзмерения = ЕдиницаПоКлассификатору;
	УпаковкаПаллета.Владелец = Объект.Ссылка;
	УпаковкаПаллета.Числитель = 1;
	УпаковкаПаллета.Знаменатель = 1;  
	УпаковкаПаллета.Родитель = УпаковкаКоробка.Ссылка; 
	УпаковкаПаллета.ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина); 
	УпаковкаПаллета.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин.Упаковка;
	УпаковкаПаллета.Записать();
	
КонецПроцедуры     

&НаСервере
Функция бг_ЕдиницаПоКлассфикаторуПоТипу(ТипЕдиницыИзмерения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УпаковкиЕдиницыИзмерения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
		|ГДЕ
		|	УпаковкиЕдиницыИзмерения.бг_ТипЕдиницыИзмерения = &бг_ТипЕдиницыИзмерения
		|	И УпаковкиЕдиницыИзмерения.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("бг_ТипЕдиницыИзмерения", ТипЕдиницыИзмерения);
	Запрос.УстановитьПараметр("Владелец", Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьПолеСтатьяКалькуляции()
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_СтатьяКалькуляции",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_СтатьяКалькуляции");
	
КонецПроцедуры

Процедура бг_СоздатьШтучнуюУпаковку()
	
	Если Не ЗначениеЗаполнено(Объект.ВидНоменклатуры)
		Или Не ЗначениеЗаполнено(Объект.ЕдиницаИзмерения)
		Или Не Объект.ИспользоватьУпаковки Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Не Справочники.Номенклатура.бг_ВыгружаетсяВWMS(Объект.ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ШтучнаяУпаковка = Справочники.Номенклатура.бг_ШтучнаяУпаковка(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(ШтучнаяУпаковка) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Владелец", Объект.Ссылка);
	ДанныеЗаполнения.Вставить("ТипИзмеряемойВеличины", Перечисления.ТипыИзмеряемыхВеличин.Упаковка);
	
	ШтучнаяУпаковкаОбъект = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
	ШтучнаяУпаковкаОбъект.Заполнить(ДанныеЗаполнения);
	
	ШтучнаяУпаковкаОбъект.ЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
	ШтучнаяУпаковкаОбъект.Числитель = 1;
	ШтучнаяУпаковкаОбъект.Знаменатель = 1;
	
	ШтучнаяУпаковкаОбъект.Наименование = Справочники.УпаковкиЕдиницыИзмерения.СформироватьНаименование(
		ШтучнаяУпаковкаОбъект.ТипУпаковки,
		Объект.ЕдиницаИзмерения,
		ШтучнаяУпаковкаОбъект.Числитель,
		ШтучнаяУпаковкаОбъект.Знаменатель,
		Объект.ЕдиницаИзмерения);
	
	ШтучнаяУпаковкаОбъект.Записать();

КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_ЕстьОшибкиЗаполненияШтрихкодовУпаковок(Номенклатура)
		
	Возврат бг_Номенклатура.ЕстьОшибкиЗаполненияШтрихкодовУпаковок(Номенклатура);
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьКомандуВыгрузить()
	
	КнопкаВыгрузить = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_Выгрузить",
		Элементы.ПодменюПерейти,
		НСтр("ru = 'Выгрузить напрямую в УПП'"),
		"бг_Выгрузить",
		"бг_Выгрузить",,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
		
	КнопкаВыгрузить.Видимость = Пользователи.РолиДоступны("бг_ИспользованиеКомандыВыгрузитьНоменклатуруВУПП");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_Выгрузить(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = Нстр("ru = 'Данные еще не записаны.
		|Выгрузить в УПП возможно только после записи элемента.
		|Записать элемент?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения(
			"бг_ВыгрузитьВопросЗавершение",
			 ЭтотОбъект),
			 ТекстВопроса,
			  РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;

	ТекстВопроса = Нстр("ru = 'Номенклатура выгрузится в УПП напрямую. Продолжить?'");
	
	ПоказатьВопрос(Новый ОписаниеОповещения(
			"бг_ЗарегистрироватьСообщениеКВыгрузкеЗавершение",
			 ЭтотОбъект),
			 ТекстВопроса,
			  РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура бг_ЗарегистрироватьСообщениеКВыгрузкеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	бг_ЗарегистрироватьСообщениеКВыгрузке();
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗарегистрироватьСообщениеКВыгрузке()
   	
	бг_ОбщегоНазначенияСервер.ЗарегистрироватьИсходящееСообщениеПриЗаписи(
			Объект.Ссылка, 
			Новый Структура("ВыгрузитьСТегомERP", Истина));	
		
КонецПроцедуры

&НаКлиенте
Процедура бг_ВыгрузитьВопросЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ЭлементЗаписан = Записать();
	Исключение
		Возврат;
	КонецПопытки;
	
	Если Не ЭлементЗаписан Тогда
		Возврат;
	КонецЕсли;
  	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТемператураОтПриИзменении(Элемент)
	
	ПредставлениеТемпературыХранения = бг_ПредставлениеТемпературыХранения(Объект.бг_ТемператураОт, 
		Объект.бг_ТемператураДо, Объект.бг_Влажность);
	Если ЗначениеЗаполнено(ПредставлениеТемпературыХранения) Тогда
		Объект.бг_ТемператураХранения = ПредставлениеТемпературыХранения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТемператураДоПриИзменении(Элемент)
	
	ПредставлениеТемпературыХранения = бг_ПредставлениеТемпературыХранения(Объект.бг_ТемператураОт, 
		Объект.бг_ТемператураДо, Объект.бг_Влажность);
	Если ЗначениеЗаполнено(ПредставлениеТемпературыХранения) Тогда
		Объект.бг_ТемператураХранения = ПредставлениеТемпературыХранения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ВлажностьПриИзменении(Элемент)
	
	ПредставлениеТемпературыХранения = бг_ПредставлениеТемпературыХранения(Объект.бг_ТемператураОт, 
		Объект.бг_ТемператураДо, Объект.бг_Влажность);
	Если ЗначениеЗаполнено(ПредставлениеТемпературыХранения) Тогда
		Объект.бг_ТемператураХранения = ПредставлениеТемпературыХранения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_ПредставлениеТемпературыХранения(ТемператураОт, ТемператураДо, Влажность)
	Возврат Справочники.Номенклатура.бг_ПредставлениеТемпературыХранения(ТемператураОт, ТемператураДо, Влажность);
КонецФункции
#КонецОбласти
