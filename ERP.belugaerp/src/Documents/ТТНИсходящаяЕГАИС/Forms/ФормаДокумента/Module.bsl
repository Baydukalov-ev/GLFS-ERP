
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриЧтенииНаСервереПеред(ТекущийОбъект)
	
	бг_ДобавитьРеквизитыФормы();
	бг_ЗаполнитьСлужебныеДанные();
	
КонецПроцедуры

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		бг_ДобавитьРеквизитыФормы();
		бг_ЗаполнитьСлужебныеДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьПоляДвижениеМарок();
	бг_ДобавитьПоляФиксацииЕГАИС();
	
	бг_УстановитьВидимостьПолейАлкогольнойПродукции();
	бг_УстановитьДоступностьТранспортногоРаздела();
	
КонецПроцедуры

&НаСервере
Процедура бг_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	бг_УстановитьВидимостьПолейАлкогольнойПродукции();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура бг_ПроверкаОтгружаемыхШтрихкодовНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда
		
		ОповещениеПоЗавершении = Новый ОписаниеОповещения(
			"бг_ПроверкаОтгружаемыхШтрихкодовНажатиеПослеВопроса",
			ЭтотОбъект);
		
		ПоказатьВопрос(
			ОповещениеПоЗавершении,
			НСтр("ru='Документ предварительно необходимо записать. Записать?'"),
			РежимДиалогаВопрос.ДаНет);
			
	Иначе
			
		бг_ПроверкаОтгружаемыхШтрихкодовНажатиеЗавершение();		
			
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура бг_ПроверкаОтгружаемыхШтрихкодовНажатиеПослеВопроса(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма, Истина);

	бг_ПроверкаОтгружаемыхШтрихкодовНажатиеЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ПроверкаОтгружаемыхШтрихкодовНажатиеЗавершение()

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТТНИсходящаяЕГАИС", Объект.Ссылка);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	Если Не Объект.ЕстьРасхождения Тогда
		ПараметрыФормы.Вставить("КлючВарианта", "ОтгружаемыеМаркиБезРасхождений");
	Иначе
		ПараметрыФормы.Вставить("КлючВарианта", "ОтгружаемыеМаркиСРасхождениями");
	КонецЕсли;
	
	ОткрытьФорму(
		"Отчет.бг_АнализОтгружаемыхМарок.ФормаОбъекта",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор,
		, // Окно
		, // НавигационнаяСсылка
		, // ОписаниеОповещенияОЗакрытии
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылкиВместо(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();

	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтказатьсяОтНакладной" Тогда

		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Отправить акт отказа по ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПодтвердитьАктОРасхождениях" Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Подтвердить акт расхождений ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтказатьсяОтАктаОРасхождениях" Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Отклонить акт расхождений ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПодтвердитьЗапросНаОтменуПроведения"
				И Объект.ЕстьРасхождения Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Подтвердить отмену проведения акта расхождения ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтказатьсяОтЗапросаНаОтменуПроведения"
				И Объект.ЕстьРасхождения Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Отклонить отмену проведения акта расхождения ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПодтвердитьЗапросНаОтменуПроведения"
				И Не Объект.ЕстьРасхождения Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Подтвердить отмену проведения акта подтверждения ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтказатьсяОтЗапросаНаОтменуПроведения"
				И Не Объект.ЕстьРасхождения Тогда
				
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Отклонить отмену проведения акта подтверждения ""%1""?'"), Объект.Ссылка);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);	
		
	Иначе
		
		ПродолжитьВызов(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СканированиеАлкогольнойПродукции

&НаСервере
&После("ОбновитьИнформациюОткрытияФормыСканирования")
Процедура бг_ОбновитьИнформациюОткрытияФормыСканирования()
	
	бг_УстановитьВидимостьПолейАлкогольнойПродукции();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьРеквизитыФормы()
	
	ДобавляемыеРеквизиты = Новый Массив;
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "бг_ЭтоКонтролерЕГАИС") Тогда
		
		ДобавляемыеРеквизиты.Добавить(
			Новый РеквизитФормы(
				"бг_ЭтоКонтролерЕГАИС",
				Новый ОписаниеТипов("Булево")));
	
	КонецЕсли;
	
	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗаполнитьСлужебныеДанные()

	ЭтотОбъект["бг_ЭтоКонтролерЕГАИС"] = РольДоступна("бг_КонтролерЕГАИС");

КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьПолейАлкогольнойПродукции()

	Элементы.ГруппаСканированиеИПроверкаАлкогольнойПродукции.Видимость = Ложь;
	Элементы.ТоварыИндексАкцизнойМарки.Видимость = Ложь;
	
	бг_ГиперссылкаПроверкиОтгружаемыхШтрихкодов().Видимость =
		ЗначениеЗаполнено(Объект.Ссылка)
		И бг_ИнтеграцияЕГАИСПовтИсп.ИспользоватьМеханизмДвиженийМарок(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьДоступностьТранспортногоРаздела()

	Элементы.Перевозчик.ТолькоПросмотр = Истина; 
	Элементы.Заказчик.ТолькоПросмотр = Истина;
    Элементы.ПунктПогрузки.ТолькоПросмотр = Истина;
	Элементы.ПунктРазгрузки.ТолькоПросмотр = Истина;
	Элементы.Экспедитор.ТолькоПросмотр = Истина; 
	Элементы.Водитель.ТолькоПросмотр = Истина;
    Элементы.ТипДоставки.ТолькоПросмотр = Истина;
    Элементы.ТипТранспорта.ТолькоПросмотр = Истина;
    Элементы.Автомобиль.ТолькоПросмотр = Истина;
	Элементы.Прицеп.ТолькоПросмотр = Истина; 
	Элементы.Перенаправление.ТолькоПросмотр = Истина;  
	 Элементы.ТоварВПутиПринадлежитГрузополучателю.ТолькоПросмотр = Истина;
   
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляДвижениеМарок()

	ГиперссылкаПроверкиОтгружаемыхШтрихкодов = бг_ГиперссылкаПроверкиОтгружаемыхШтрихкодов();

КонецПроцедуры

&НаСервере
Функция бг_ГиперссылкаПроверкиОтгружаемыхШтрихкодов()

	ГиперссылкаПроверкиОтгружаемыхШтрихкодов = Элементы.Найти("бг_ПроверкаОтгружаемыхШтрихкодов");
	Если ГиперссылкаПроверкиОтгружаемыхШтрихкодов <> Неопределено Тогда
		Возврат ГиперссылкаПроверкиОтгружаемыхШтрихкодов;
	КонецЕсли;
	
	ГиперссылкаПроверкиОтгружаемыхШтрихкодов = Элементы.Вставить(
		"бг_ПроверкаОтгружаемыхШтрихкодов",
		Тип("ДекорацияФормы"),
		Элементы.СтраницаТовары,
		Элементы.ГруппаСканированиеИПроверкаАлкогольнойПродукции);
		
	ГиперссылкаПроверкиОтгружаемыхШтрихкодов.Вид = ВидДекорацииФормы.Надпись;
	ГиперссылкаПроверкиОтгружаемыхШтрихкодов.Гиперссылка = Истина;
	ГиперссылкаПроверкиОтгружаемыхШтрихкодов.Заголовок = "Проверить отгружаемые штрихкоды";
	ГиперссылкаПроверкиОтгружаемыхШтрихкодов.УстановитьДействие("Нажатие", "бг_ПроверкаОтгружаемыхШтрихкодовНажатие");
	
	Возврат ГиперссылкаПроверкиОтгружаемыхШтрихкодов;
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьПоляФиксацииЕГАИС()
	Элементбг_ДатаФиксацииЕГАИС = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
			ЭтотОбъект,
			"бг_ДатаФиксацииЕГАИС", 
			Элементы.СтраницаОсновное,
			"Объект.бг_ДатаФиксацииЕГАИС");
	Элементбг_ДатаФиксацииЕГАИС.ТолькоПросмотр = Истина;
	Элементбг_НомерФиксацииЕГАИС = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
			ЭтотОбъект,
			"бг_НомерФиксацииЕГАИС", 
			Элементы.СтраницаОсновное,
			"Объект.бг_НомерФиксацииЕГАИС");
	Элементбг_НомерФиксацииЕГАИС.ТолькоПросмотр = Истина;
	Элементбг_НомерФиксацииЕГАИС.АвтоМаксимальнаяШирина = Ложь;
	Элементбг_НомерФиксацииЕГАИС.МаксимальнаяШирина = 28;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
&После("УправлениеДоступностьюЭлементовФормы")
Процедура бг_УправлениеДоступностьюЭлементовФормы(Форма)
	
	Форма.Элементы.Товары.ТолькоПросмотр = Истина;
	Форма.Элементы.ТоварыГруппаКоманднаяПанель.Доступность = Ложь;
	Форма.Элементы.ДатаОтгрузки.Доступность = Ложь;

КонецПроцедуры

#КонецОбласти

