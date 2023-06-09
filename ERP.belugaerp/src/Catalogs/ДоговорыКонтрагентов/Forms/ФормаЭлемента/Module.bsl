
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
		
	бг_ДобавитьРеквизитыСоглашения();
	бг_УстановитьВидимостьСоглашения();
	
	бг_ДобавитьЭлементыМагистраль();
	бг_УстановитьДоступностьНастроекМагистраль();
	
	бг_ДобавитьЭлементыТранспортнаяЛогистика();
	
	бг_ДобавитьЭлементПроцентФинансированияФакторинга();
	бг_УстановитьВидимостьПроцентФинансированияФакторинга();
	
КонецПроцедуры

&НаСервере
Процедура бг_ОбработкаПроверкиЗаполненияНаСервереПеред(Отказ, ПроверяемыеРеквизиты)
	
	бг_ПроверитьЗаполнениеМагистраль(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура бг_СоглашениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСоглашения = ПродажиКлиент.ПараметрыНачалаВыбораСоглашенияСКлиентом();
	
	ПараметрыВыбораСоглашения.Элемент = Элемент;
	ПараметрыВыбораСоглашения.Партнер = Объект.Партнер;
	ПараметрыВыбораСоглашения.Организация = Объект.Организация;
	ПараметрыВыбораСоглашения.Документ = Объект.бг_Соглашение;
	ПараметрыВыбораСоглашения.ДатаДокумента = Объект.Дата;
	ПараметрыВыбораСоглашения.ДанныеФормыСтруктура = Объект;

	ПродажиКлиент.НачалоВыбораСоглашенияСКлиентом(ПараметрыВыбораСоглашения, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура бг_ТипДоговораПриИзмененииПосле(Элемент)
	
	ТипДоговораПриИзмененииПослеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СтатьяДвиженияДенежныхСредствОбработкаВыбораПеред(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Объект.бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС
		И ЗначениеЗаполнено(ВыбранноеЗначение)
		И бг_ЭтоПредопределеннаяСтатьяДДС(ВыбранноеЗначение) Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекстОшибки = НСтр("ru = 'При включенных настройках проекта ""Магистраль""
                            |запрещен выбор предопределенных элементов'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,
			,
			"Объект.СтатьяДвиженияДенежныхСредств");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура бг_НастройкиОплатыЧерезФакторинговуюКомпаниюПередОкончаниемРедактирования(Элемент, 
	НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если Отказ Или (НоваяСтрока И ОтменаРедактирования) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.бг_НастройкиОплатыЧерезФакторинговуюКомпанию.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончанияДействия) Тогда
		ТекущиеДанные.ДатаОкончанияДействия = Дата(3999, 12, 31);
	КонецЕсли;
	
	Если ТекущиеДанные.ДатаОкончанияДействия < ТекущиеДанные.ДатаНачалаДействия Тогда
		ТекстОшибки = НСтр("ru = 'Дата окончания не может быть меньше даты начала'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,
			,
			"бг_НастройкиОплатыЧерезФакторинговуюКомпанию[" + (ТекущиеДанные.НомерСтроки - 1) + "].ДатаОкончанияДействия",
			,
			Отказ);
	КонецЕсли;
	
	Если бг_ЕстьПересечениеПоИнтерваламФакторинга(ТекущиеДанные) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Отказ И Не ОтменаРедактирования Тогда
		Объект.бг_НастройкиОплатыЧерезФакторинговуюКомпанию.Сортировать("ДатаНачалаДействия, ДатаОкончанияДействия");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТипДоговораПриИзмененииПослеНаСервере()
	
	бг_УстановитьВидимостьСоглашения();
	бг_УстановитьДоступностьНастроекМагистраль();
	бг_УстановитьВидимостьПроцентФинансированияФакторинга();
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьРеквизитыСоглашения()
	
	бг_ВидВзаиморасчетов = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ВидВзаиморасчетов",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ВидВзаиморасчетов");
	бг_ВидВзаиморасчетов.АвтоМаксимальнаяШирина = Ложь;
	бг_ВидВзаиморасчетов.МаксимальнаяШирина = 28;
	
	бг_Соглашение = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Соглашение",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_Соглашение");
	бг_Соглашение.АвтоМаксимальнаяШирина = Ложь;
	бг_Соглашение.МаксимальнаяШирина = 28;
	
	бг_Соглашение.УстановитьДействие("НачалоВыбора", "бг_СоглашениеНачалоВыбора");
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьСоглашения()

	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту Тогда
		Элементы.бг_Соглашение.Видимость = Истина;
	Иначе
		Элементы.бг_Соглашение.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыМагистраль()
	
	РазрешеноРедактирование = Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНастроекМагистраль");
	
	бг_СтраницаМагистраль = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьСтраницуНаФорму(
		ЭтотОбъект,
		"бг_СтраницаМагистраль",
		НСтр("ru = 'Проект ""Магистраль""'"),
		"ГруппаСтраницы");
	
	бг_ГруппаШапкаМагистраль = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
		ЭтотОбъект,
		"бг_ГруппаШапкаМагистраль",
		бг_СтраницаМагистраль,
		ВидГруппыФормы.ОбычнаяГруппа);
	бг_ГруппаШапкаМагистраль.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС =
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС",
		бг_ГруппаШапкаМагистраль,
		"Объект.бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС",
		,
		,
		"ПолеФлажка");
	бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС.ВидФлажка = ВидФлажка.Выключатель;
			
	бг_ОтсрочкаПлатежа = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ОтсрочкаПлатежа",
		бг_ГруппаШапкаМагистраль,
		"Объект.бг_ОтсрочкаПлатежа");
	бг_ОтсрочкаПлатежа.Подсказка = НСтр("ru = 'Только для договора с переработчиком,
                                              |для остальных договоров отсрочка указывается в соглашении'");
	
	бг_ШаблонТекстаНазначенияПлатежа = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ШаблонТекстаНазначенияПлатежа",
		бг_ГруппаШапкаМагистраль,
		"Объект.бг_ШаблонТекстаНазначенияПлатежа");
	бг_ШаблонТекстаНазначенияПлатежа.РежимВыбораИзСписка = Истина;
	бг_Магистраль.ЗаполнитьСписокШаблонов(бг_ШаблонТекстаНазначенияПлатежа.СписокВыбора);
	
	бг_ГруппаФакторингМагистраль = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
		ЭтотОбъект,
		"бг_ГруппаФакторингМагистраль",
		бг_СтраницаМагистраль,
		ВидГруппыФормы.ОбычнаяГруппа);
	бг_ГруппаФакторингМагистраль.Заголовок = НСтр("ru = 'Факторинг'");
	бг_ГруппаФакторингМагистраль.ОтображатьЗаголовок = Истина;
	
	бг_НастройкиОплатыЧерезФакторинговуюКомпанию = 
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьТаблицуНаФорму(
		ЭтотОбъект,
		"бг_НастройкиОплатыЧерезФакторинговуюКомпанию",
		бг_ГруппаФакторингМагистраль,
		"Объект.бг_НастройкиОплатыЧерезФакторинговуюКомпанию");
	бг_НастройкиОплатыЧерезФакторинговуюКомпанию.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	бг_НастройкиОплатыЧерезФакторинговуюКомпанию.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Верх;
	бг_НастройкиОплатыЧерезФакторинговуюКомпанию.АвтоВводНовойСтроки = Ложь;
	
	МетаданныеТЧНастройкиОплатыЧерезФакторинговуюКомпанию = 
		Объект.Ссылка.Метаданные().ТабличныеЧасти["бг_НастройкиОплатыЧерезФакторинговуюКомпанию"];
	ПолеТЧ = Элементы.Добавить("КолонкаНомерСтроки", Тип("ПолеФормы"), бг_НастройкиОплатыЧерезФакторинговуюКомпанию);
	ПолеТЧ.ПутьКДанным = "Объект.бг_НастройкиОплатыЧерезФакторинговуюКомпанию.НомерСтроки";
	Для каждого КолонкаТЧ Из МетаданныеТЧНастройкиОплатыЧерезФакторинговуюКомпанию.Реквизиты Цикл
		ПолеТЧ = Элементы.Добавить("Колонка" + КолонкаТЧ.Имя, Тип("ПолеФормы"), бг_НастройкиОплатыЧерезФакторинговуюКомпанию);
		ПолеТЧ.Вид = ВидПоляФормы.ПолеВвода;
		ПолеТЧ.ПутьКДанным = "Объект.бг_НастройкиОплатыЧерезФакторинговуюКомпанию." + КолонкаТЧ.Имя;
	КонецЦикла;
	
	Для каждого ПодчиненныйЭлемент Из бг_СтраницаМагистраль.ПодчиненныеЭлементы Цикл
		ПодчиненныйЭлемент.ТолькоПросмотр = Не РазрешеноРедактирование;
	КонецЦикла;
	
	бг_НастройкиОплатыЧерезФакторинговуюКомпанию.УстановитьДействие(
		"ПередОкончаниемРедактирования", "бг_НастройкиОплатыЧерезФакторинговуюКомпаниюПередОкончаниемРедактирования");
	
	Элементы.СтатьяДвиженияДенежныхСредств.УстановитьДействие("ОбработкаВыбора",
		"бг_СтатьяДвиженияДенежныхСредствОбработкаВыбораПеред");
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыТранспортнаяЛогистика()
	бг_ВидПеревозки = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ВидПеревозки",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ВидПеревозки");
	бг_ВидПеревозки.АвтоМаксимальнаяШирина = Ложь;
	бг_ВидПеревозки.МаксимальнаяШирина = 28;
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьДоступностьНастроекМагистраль()
	
	Если Элементы.Найти("бг_ОтсрочкаПлатежа") <> Неопределено Тогда
		Если Не Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНастроекМагистраль") Тогда
			Элементы.бг_ОтсрочкаПлатежа.ТолькоПросмотр = Истина;
		Иначе
			Элементы.бг_ОтсрочкаПлатежа.ТолькоПросмотр = Объект.ТипДоговора <> Перечисления.ТипыДоговоров.СПереработчиком;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.Найти("бг_СтраницаМагистраль") <> Неопределено Тогда
		Элементы.бг_СтраницаМагистраль.Видимость = Перечисления.ТипыДоговоров.ЭтоДоговорЗакупки(Объект.ТипДоговора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция бг_ЕстьПересечениеПоИнтерваламФакторинга(СтрокаНастройкиФакторинга)
	
	Для каждого СтрокаНастроек Из Объект.бг_НастройкиОплатыЧерезФакторинговуюКомпанию Цикл
		Если СтрокаНастроек.НомерСтроки = СтрокаНастройкиФакторинга.НомерСтроки Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаНастройкиФакторинга.ДатаНачалаДействия <= СтрокаНастроек.ДатаОкончанияДействия
			И СтрокаНастройкиФакторинга.ДатаОкончанияДействия >= СтрокаНастроек.ДатаНачалаДействия Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Интервал пересекается с интервалом в строке %1'"), СтрокаНастроек.НомерСтроки);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки,
				,
				"бг_НастройкиОплатыЧерезФакторинговуюКомпанию[" + 
					(СтрокаНастройкиФакторинга.НомерСтроки - 1) + "].ДатаОкончанияДействия");
				
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Функция бг_ЭтоПредопределеннаяСтатьяДДС(СтатьяДвиженияДенежныхСредств)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтатьяДвиженияДенежныхСредств, "Предопределенный");
	
КонецФункции

Процедура бг_ПроверитьЗаполнениеМагистраль(Отказ)
	
	Если Не Объект.бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.БанковскийСчетКонтрагента) Тогда
		ТекстОшибки = НСтр("ru = 'В договоре не заполнен банковский счет контрагента'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
	Иначе
		РеквизитыБанковскогоСчета = 
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.БанковскийСчетКонтрагента, "Банк, ПометкаУдаления");
		
		Если РеквизитыБанковскогоСчета.ПометкаУдаления Тогда
			ТекстОшибки = НСтр("ru = 'Банковский счет контрагента в договоре помечен на удаление'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "БанковскийСчетКонтрагента", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(РеквизитыБанковскогоСчета.Банк)
			Или Не ОбщегоНазначения.СсылкаСуществует(РеквизитыБанковскогоСчета.Банк) Тогда
			ТекстОшибки = НСтр("ru = 'В банковском счете контрагента не заполнен банк'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "БанковскийСчетКонтрагента", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.СтатьяДвиженияДенежныхСредств) Тогда
		ТекстОшибки = НСтр("ru = 'В договоре не заполнена статья движения денежных средств'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "СтатьяДвиженияДенежныхСредств", , Отказ);
	Иначе
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДвиженияДенежныхСредств,
			"Предопределенный") = Истина Тогда
			ТекстОшибки = НСтр("ru = 'В договоре выбрана предопределенная статья движения денежных средств'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "СтатьяДвиженияДенежныхСредств", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.бг_ШаблонТекстаНазначенияПлатежа) Тогда
		ТекстОшибки = НСтр("ru = 'В договоре не заполнен шаблон назначения платежа (Магистраль)'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "бг_ШаблонТекстаНазначенияПлатежа", , Отказ);
	КонецЕсли;
	
	Если Объект.ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
		И Не ЗначениеЗаполнено(Объект.бг_ОтсрочкаПлатежа) Тогда
		ТекстОшибки = НСтр("ru = 'В договоре не заполнена отсрочка платежа (Магистраль)'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "бг_ОтсрочкаПлатежа", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементПроцентФинансированияФакторинга()
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ПроцентФинансированияФакторинга",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ПроцентФинансированияФакторинга");
	Элемент.АвтоМаксимальнаяШирина = Ложь;
	
	СтандартнаяШирина = 28;
	Элемент.МаксимальнаяШирина = СтандартнаяШирина;
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьПроцентФинансированияФакторинга()
	
	ВидимостьЭлементаПоПравам = ПравоДоступа("Изменение", Метаданные.Документы.битФакторинг);
	
	ВидимостьЭлементаПоОперации = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	
	Элементы.бг_ПроцентФинансированияФакторинга.Видимость = ВидимостьЭлементаПоПравам И ВидимостьЭлементаПоОперации;
	
КонецПроцедуры

#КонецОбласти
