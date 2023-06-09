
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НовыйМассив = Новый Массив;
	НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидНоменклатуры", бг_КонстантыПовтИсп.ЗначениеКонстанты("ФедеральнаяСпецМарка"));
    НовыйМассив.Добавить(НовыйПараметр);
	Элементы.ТоварыНоменклатура.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
	
	Если Объект.Ссылка.Пустая() Тогда
		УстановитьОрганизациюЕГАИС(Объект);
	КонецЕсли	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьИнформациюОПодчиненномДокументе();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НакладнаяНаВыдачуФСМ", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОрганизациюЕГАИС(Объект);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Партнер) Тогда
		Объект.Соглашение = ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка");
		Возврат;
	КонецЕсли;
	
	ПартнерПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеОтборы = Новый Структура;
	ДополнительныеОтборы.Вставить("ИспользуютсяДоговорыКонтрагентов", Истина);
	
	ЗакупкиКлиент.НачалоВыбораСоглашенияСПоставщиком(
		Элемент,
		СтандартнаяОбработка,
		Объект.Партнер,
		Объект.Соглашение,
		Объект.Дата,
		ДополнительныеОтборы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеПриИзменении(Элемент)
	
	СоглашениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеОВыдачеФСМПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.ЗаявлениеОВыдачеФСМ) Тогда
		Возврат;
	КонецЕсли;
	
	// Ввиду особой специфики выбранного подхода заполняния накладной на основании
	// заявления на выдачу ФСМ, необходимо, чтобы ссылка на накладную ФСМ уже существовала.
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	КонецЕсли;
	
	ЗаявлениеОВыдачеФСМПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОрганизацияПриИзмененииНаСервере()

	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект,
		Элементы.Договор.Доступность,
		Элементы.Договор.Видимость,
		Объект.Договор);
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗаполнитьДоговорПоУмолчаниюСервер();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()

	Если Не ЗначениеЗаполнено(Объект.Партнер) Тогда
		Возврат;
	КонецЕсли;
		
	КлючиУсловийЗакупок = "УчитыватьГруппыСкладов, ИсключитьГруппыСкладовДоступныеВЗаказах, ВыбранноеСоглашение";
	ОтборУсловийЗакупок = Новый Структура(КлючиУсловийЗакупок, Истина, Истина, Объект.Соглашение);
	УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(Объект.Партнер, ОтборУсловийЗакупок);
	
	ХозяйственнаяОперацияДоговора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
	НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка");
	ВалютаВзаиморасчетов = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
	
	Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
		
		Если Объект.Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
			И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
			
			Объект.Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			
			Если ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Организация) И УсловияЗакупокПоУмолчанию.Организация <> Объект.Организация Тогда
				Объект.Организация = УсловияЗакупокПоУмолчанию.Организация;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Склад) Тогда
				Объект.Склад = УсловияЗакупокПоУмолчанию.Склад;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Контрагент) И УсловияЗакупокПоУмолчанию.Контрагент <> Объект.Контрагент Тогда
				Объект.Контрагент = УсловияЗакупокПоУмолчанию.Контрагент;
				БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Объект.Контрагент);
			КонецЕсли;
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
			
			Если УсловияЗакупокПоУмолчанию.ИспользуютсяДоговорыКонтрагентов <> Неопределено
				И УсловияЗакупокПоУмолчанию.ИспользуютсяДоговорыКонтрагентов Тогда
				
				ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
				ДопПараметры.ВалютаВзаиморасчетов = УсловияЗакупокПоУмолчанию.ВалютаВзаиморасчетов;
				ДопПараметры.Налогообложение = НалогообложениеНДС;
				
				Объект.Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Объект, ХозяйственнаяОперацияДоговора, ДопПараметры);
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
			Объект.Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
		КонецЕсли;
		
	Иначе
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
		Объект.Соглашение = Неопределено;
		
		ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
		ДопПараметры.ВалютаВзаиморасчетов = ВалютаВзаиморасчетов;
		
		Объект.Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Объект, ХозяйственнаяОперацияДоговора, ДопПараметры);
		
	КонецЕсли;
	
	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект,
		Элементы.Договор.Доступность,
		Элементы.Договор.Видимость,
		Объект.Договор);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()

	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект,
		Элементы.Договор.Доступность,
		Элементы.Договор.Видимость,
		Объект.Договор);

	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ЗаполнитьДоговорПоУмолчаниюСервер();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура СоглашениеПриИзмененииНаСервере()
	
	ЗакупкиСервер.УстановитьДоступностьДоговора(
		Объект,
		Элементы.Договор.Доступность,
		Элементы.Договор.Видимость,
		Объект.Договор);
		
	ХозяйственнаяОперацияДоговора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
	НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка");
	ВалютаВзаиморасчетов = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
	
	Если ЗначениеЗаполнено(Объект.Соглашение) Тогда
		
		УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Объект.Соглашение, Истина, Истина);

		Валюта = УсловияЗакупок.Валюта;
		ВалютаВзаиморасчетов = УсловияЗакупок.ВалютаВзаиморасчетов;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Объект.Организация Тогда
			Объект.Организация = УсловияЗакупок.Организация;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.Склад) Тогда
			Объект.Склад = УсловияЗакупок.Склад;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Объект.Контрагент Тогда
			Объект.Контрагент = УсловияЗакупок.Контрагент;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
					
		ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
		ДопПараметры.ВалютаВзаиморасчетов = ВалютаВзаиморасчетов;
		ДопПараметры.Налогообложение = НалогообложениеНДС;
		
		Объект.Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Объект, ХозяйственнаяОперацияДоговора, ДопПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоговорПоУмолчаниюСервер()
	
	ХозяйственнаяОперацияОтбора = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");

	ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
	ДопПараметры.ВалютаВзаиморасчетов = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
	ДопПараметры.НаправлениеДеятельности = ПредопределенноеЗначение("Справочник.НаправленияДеятельности.ПустаяСсылка");
	ДоговорПоУмолчанию = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Объект, ХозяйственнаяОперацияОтбора, ДопПараметры);
		
	ИспользуютсяДоговорыПоСоглашению = Не ЗначениеЗаполнено(Объект.Соглашение)
		Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Соглашение, "ИспользуютсяДоговорыКонтрагентов");
		
	Если Не ЗначениеЗаполнено(Объект.Договор)
		И ИспользуютсяДоговорыПоСоглашению Тогда
		
		Объект.Договор = ДоговорПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОрганизациюЕГАИС(Объект)
	
	Объект.ОрганизацияЕГАИС = ОрганизацияЕГАИС(Объект.Организация)

КонецПроцедуры	

&НаСервереБезКонтекста
Функция ОрганизацияЕГАИС(Организация)
	
	Возврат
		Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(
			Организация,
			Справочники.Склады.ПустаяСсылка(),
			Истина, // СоответствуетОрганизации
			Ложь);  // ТолькоСопоставленные

КонецФункции

&НаСервере
Процедура ЗаявлениеОВыдачеФСМПриИзмененииНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьНоменклатуруТоваровПоЗаявлениюНаВыдачуФСМ(Объект.Ссылка);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриобретениеТоваровУслугНажатие(Элемент)
	
	Если ЗначениеЗаполнено(ПриобретениеТоваровУслуг) Тогда
		
		ПоказатьЗначение(, ПриобретениеТоваровУслуг);
		
	Иначе
		
		ПоказатьПредупреждение(, "Не создан документ ""Приобретение товаров и услуг""");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОПодчиненномДокументе()
	
	ПриобретениеТоваровУслуг = Неопределено;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПодчиненныеДокументы = Документы.битНакладнаяНаВыдачуФСМ.ПодчиненныеДокументы(Объект.Ссылка);
		
		Для каждого СтрокаТЧ Из ПодчиненныеДокументы Цикл
			Если СтрокаТЧ.ИмяДокумента = "ПриобретениеТоваровУслуг" Тогда
				ПриобретениеТоваровУслуг = СтрокаТЧ.Документ;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПриобретениеТоваровУслуг) Тогда
		Элементы.ПриобретениеТоваровУслуг.Заголовок = Строка(ПриобретениеТоваровУслуг);
	Иначе
		Элементы.ПриобретениеТоваровУслуг.Заголовок = "<Не создан документ ""Приобретение товаров и услуг"">";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом  
	
КонецПроцедуры

#КонецОбласти
