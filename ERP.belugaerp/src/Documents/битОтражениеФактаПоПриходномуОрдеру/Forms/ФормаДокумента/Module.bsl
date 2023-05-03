
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	КартинкиТиповУпаковок = бг_МаркируемаяПродукция.КартинкиТиповУпаковок();
	ЗначенияТиповУпаковок = бг_МаркируемаяПродукция.ЗначенияТиповУпаковок();
	ДлиныШтрихкодовМарок = бг_МаркируемаяПродукция.ДлиныШтрихкодовМарок();
	
	ПриПолученииДанныхНаСервере();
	
	УстановитьВидимостьЭлементов();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПроверитьПринимаемыеШтрихкодыНажатие(Элемент)
	
	Если Объект.РезультатПриемки = ПредопределенноеЗначение("Перечисление.бг_РезультатыПриемкиWMS.ЕстьРасхожденияОтПлана")
		И (Не ЗначениеЗаполнено(Объект.Ссылка)
			Или Модифицированность
			Или Не Объект.Проведен) Тогда
			
		ОповещениеПоЗавершении = Новый ОписаниеОповещения(
			"ПроверитьПринимаемыеШтрихкодыНажатиеПослеВопроса",
			ЭтотОбъект);
			
		ПоказатьВопрос(
			ОповещениеПоЗавершении,
			НСтр("ru='Документ предварительно необходимо провести. Провести?'"),
			РежимДиалогаВопрос.ДаНет);
			
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда
		
		ОповещениеПоЗавершении = Новый ОписаниеОповещения(
			"ПроверитьПринимаемыеШтрихкодыНажатиеПослеВопроса",
			ЭтотОбъект);
			
		ПоказатьВопрос(
			ОповещениеПоЗавершении,
			НСтр("ru='Документ предварительно необходимо записать. Записать?'"),
			РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПроверитьПринимаемыеШтрихкодыНажатиеЗавершение();		
		
	КонецЕсли;

КонецПроцедуры
	
&НаКлиенте
Процедура ПроверитьПринимаемыеШтрихкодыНажатиеПослеВопроса(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.РезультатПриемки = ПредопределенноеЗначение("Перечисление.бг_РезультатыПриемкиWMS.ЕстьРасхожденияОтПлана") Тогда
		ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма, Истина);
	Иначе
		ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма, Истина);
	КонецЕсли;

	ПроверитьПринимаемыеШтрихкодыНажатиеЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПринимаемыеШтрихкодыНажатиеЗавершение()

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Документ", Объект.Ссылка);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	Если Объект.РезультатПриемки = ПредопределенноеЗначение("Перечисление.бг_РезультатыПриемкиWMS.ПолноеСоответствиеПлану") Тогда
		ПараметрыФормы.Вставить("КлючВарианта", "ПолноеСоответствиеПлану");
	Иначе
		ПараметрыФормы.Вставить("КлючВарианта", "ЕстьРасхожденияОтПлана");
	КонецЕсли;
	
	ОткрытьФорму(
		"Отчет.бг_АнализПринимаемыхМарок.ФормаОбъекта",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор,
		, // Окно
		, // НавигационнаяСсылка
		, // ОписаниеОповещенияОЗакрытии
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
 
&НаКлиенте
Процедура ПриходныйОрдерНаТоварыПриИзменении(Элемент)
	ПриходныйОрдерНаТоварыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриемкиПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусSolvoПриИзменении(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура МаркиШтрихкодПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Марки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Штрихкод = СокрЛП(ТекущиеДанные.Штрихкод);
	
	КонтекстЗаполненияДанныхТиповУпаковок = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		ТекущиеДанные,
		КонтекстЗаполненияДанныхТиповУпаковок);

КонецПроцедуры

&НаКлиенте
Процедура МаркиШтрихкодРодительПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Марки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ШтрихкодРодитель = СокрЛП(ТекущиеДанные.ШтрихкодРодитель);
	
	КонтекстЗаполненияДанныхТиповУпаковок = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"ШтрихкодРодитель",
		"ТипУпаковкиРодителя",
		"КартинкаТипаУпаковкиРодителя");
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		ТекущиеДанные,
		КонтекстЗаполненияДанныхТиповУпаковок);
		
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыШтрихкодПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Штрихкоды.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Штрихкод = СокрЛП(ТекущиеДанные.Штрихкод);
	
	КонтекстЗаполненияДанныхТиповУпаковок = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		ТекущиеДанные,
		КонтекстЗаполненияДанныхТиповУпаковок);
		
КонецПроцедуры

&НаКлиенте
Процедура УпаковкиШтрихкодПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Упаковки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Штрихкод = СокрЛП(ТекущиеДанные.Штрихкод);
	
	КонтекстЗаполненияДанныхТиповУпаковок = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		ТекущиеДанные,
		КонтекстЗаполненияДанныхТиповУпаковок);

КонецПроцедуры

&НаКлиенте
Процедура УпаковкиШтрихкодРодительПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Упаковки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ШтрихкодРодитель = СокрЛП(ТекущиеДанные.ШтрихкодРодитель);
	
	КонтекстЗаполненияДанныхТиповУпаковок = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"ШтрихкодРодитель",
		"ТипУпаковкиРодителя",
		"КартинкаТипаУпаковкиРодителя");
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		ТекущиеДанные,
		КонтекстЗаполненияДанныхТиповУпаковок);
		
КонецПроцедуры

&НаКлиенте
Процедура СтатусSolvoОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриемкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	МаркиЗаполнитьДанныеТиповУпаковок();
	УпаковкиЗаполнитьДанныеТиповУпаковок();
	ШтрихкодыЗаполнитьДанныеТиповУпаковок();
	
	ЗаполнитьВспомогательныеДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура МаркиЗаполнитьДанныеТиповУпаковок()

	КонтекстЗаполненияДанныхТиповУпаковокШтрихкод = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
		
	КонтекстЗаполненияДанныхТиповУпаковокШтрихкодРодитель = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"ШтрихкодРодитель",
		"ТипУпаковкиРодителя",
		"КартинкаТипаУпаковкиРодителя");
	
	Для каждого СтрокаМарки Из Объект.Марки Цикл
		
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаМарки,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкод);
			
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаМарки,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкодРодитель);
			
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УпаковкиЗаполнитьДанныеТиповУпаковок()

	КонтекстЗаполненияДанныхТиповУпаковокШтрихкод = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
		
	КонтекстЗаполненияДанныхТиповУпаковокШтрихкодРодитель = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"ШтрихкодРодитель",
		"ТипУпаковкиРодителя",
		"КартинкаТипаУпаковкиРодителя");
	
	Для каждого СтрокаУпаковки Из Объект.Упаковки Цикл
		
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаУпаковки,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкод);
			
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаУпаковки,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкодРодитель);
			
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ШтрихкодыЗаполнитьДанныеТиповУпаковок()

	КонтекстЗаполненияДанныхТиповУпаковокШтрихкод = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
		
	Для каждого СтрокаШтрихкоды Из Объект.Штрихкоды Цикл
		
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаШтрихкоды,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкод);
			
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВспомогательныеДанныеФормы()

	ЭтоSolvo = Объект.ТипВнешнейСкладскойСистемы = Перечисления.бг_ТипыВнешнихСкладскихСистем.Solvo;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	// Обнуляем видимость.
	Элементы.СтатусSolvo.Видимость = Ложь;
	Элементы.СтраницаМаркиУпаковки.Видимость = Ложь;
	Элементы.СтраницаОтсканированныеШтрихкоды.Видимость = Ложь;
	Элементы.СтраницаТовары.Видимость = Ложь;
	Элементы.ПроверитьПринимаемыеШтрихкоды.Видимость = Ложь;
	
	// Подготавливаем данные, влияющие на видимость.
	Если Не ЗначениеЗаполнено(Объект.ПриходныйОрдерНаТовары) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен приходный ордер'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ТипВнешнейСкладскойСистемы) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен тип WMS в складе'"));
		Возврат;
	КонецЕсли;
	
	КонечныеСтатусыSolvo = Документы.битОтражениеФактаПоПриходномуОрдеру.КонечныеСтатусыSolvo(Объект.ЕстьМаркируемаяАлкогольнаяПродукция);
	ЭтоКонечныйСтатусSolvo = КонечныеСтатусыSolvo.Найти(Объект.СтатусSolvo) <> Неопределено;
	
	ПоказыватьРезультатПриемки = ЭтоSolvo И ЭтоКонечныйСтатусSolvo Или Не ЭтоSolvo;
	
	// Устанавливаем видимость в зависимости от полученных данных.
	Элементы.СтатусSolvo.Видимость = ЭтоSolvo;
	Элементы.РезультатПриемки.Видимость = ПоказыватьРезультатПриемки;
	Элементы.СтраницаОтсканированныеШтрихкоды.Видимость = Не ЭтоSolvo;
	
	Если Объект.РезультатПриемки = Перечисления.бг_РезультатыПриемкиWMS.ПолноеСоответствиеПлану Тогда
		
		Элементы.СтраницаМаркиУпаковки.Видимость = Ложь;
		Элементы.СтраницаТовары.Видимость = ПоказыватьРезультатПриемки;
		Элементы.ПроверитьПринимаемыеШтрихкоды.Видимость = ПоказыватьРезультатПриемки И Объект.ЕстьМаркируемаяАлкогольнаяПродукция;
		
	ИначеЕсли Объект.РезультатПриемки = Перечисления.бг_РезультатыПриемкиWMS.ЕстьРасхожденияОтПлана Тогда
		
		Элементы.СтраницаМаркиУпаковки.Видимость = Объект.ЕстьМаркируемаяАлкогольнаяПродукция И ПоказыватьРезультатПриемки;
		Элементы.СтраницаТовары.Видимость = ПоказыватьРезультатПриемки;
		Элементы.ПроверитьПринимаемыеШтрихкоды.Видимость = Объект.ЕстьМаркируемаяАлкогольнаяПродукция И ПоказыватьРезультатПриемки;
		
	ИначеЕсли Объект.РезультатПриемки = Перечисления.бг_РезультатыПриемкиWMS.ПриемкаОтменена Тогда
		
		Элементы.СтраницаМаркиУпаковки.Видимость = Ложь;
		Элементы.СтраницаТовары.Видимость = Ложь;
		Элементы.ПроверитьПринимаемыеШтрихкоды.Видимость = Ложь;
		
	Иначе
		// NOP
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ВозможностьРедактированияЭлементов = Пользователи.ЭтоПолноправныйПользователь();
	
	Элементы.ПриходныйОрдерНаТовары.ТолькоПросмотр = Не ВозможностьРедактированияЭлементов;
	Элементы.ОператорТСД.ТолькоПросмотр = Не ВозможностьРедактированияЭлементов;
	Элементы.ВремяВыполнения.ТолькоПросмотр = Не ВозможностьРедактированияЭлементов;
	Элементы.СтатусSolvo.ТолькоПросмотр = Не ВозможностьРедактированияЭлементов;
	Элементы.РезультатПриемки.ТолькоПросмотр = Не ВозможностьРедактированияЭлементов;
	
	Элементы.Марки.ИзменятьПорядокСтрок = ВозможностьРедактированияЭлементов;
	Элементы.Упаковки.ИзменятьСоставСтрок = ВозможностьРедактированияЭлементов;
	Элементы.Штрихкоды.ИзменятьСоставСтрок = ВозможностьРедактированияЭлементов;
	
	Элементы.Товары.ИзменятьПорядокСтрок = ВозможностьРедактированияЭлементов;
	Элементы.Товары.ИзменятьСоставСтрок = ВозможностьРедактированияЭлементов;
	
КонецПроцедуры

&НаСервере
Процедура ПриходныйОрдерНаТоварыПриИзмененииНаСервере()
	
	ДанныеОрдераWMS = Документы.ПриходныйОрдерНаТовары.бг_ДанныеОрдераWMS(Объект.ПриходныйОрдерНаТовары);
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОрдераWMS);
	
	ЗаполнитьВспомогательныеДанныеФормы();
	
	УстановитьВидимостьЭлементов();

КонецПроцедуры

#КонецОбласти
