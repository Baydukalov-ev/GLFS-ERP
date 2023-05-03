#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьЭлементы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьЭлементы()
	
	бг_ДобавитьПоляМагистраль();
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПоляМагистраль()
	
	бг_ГруппаФакторМагистраль = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
		ЭтотОбъект,
		"бг_ГруппаФакторМагистраль",
		Элементы.ГруппаШапкаПраво,
		ВидГруппыФормы.ОбычнаяГруппа,
		Элементы.СтатьяДвиженияДенежныхСредств);
	бг_ГруппаФакторМагистраль.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	бг_ГруппаФакторМагистраль.Заголовок = НСтр("ru = 'Фактор (Проект ""Магистраль"")'");
	
	бг_Фактор =
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Фактор",
		бг_ГруппаФакторМагистраль,
		"Объект.бг_БанковскийСчетФактора.Владелец");
	бг_Фактор.Заголовок = НСтр("ru = 'Контрагент-фактор'");
	
	бг_БанковскийСчетФактора =
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_БанковскийСчетФактора",
		бг_ГруппаФакторМагистраль,
		"Объект.бг_БанковскийСчетФактора");
	
	бг_ГруппаРеквизитыМагистраль = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
		ЭтотОбъект,
		"бг_ГруппаРеквизитыМагистраль",
		Элементы.СтраницаОсновное,
		ВидГруппыФормы.ОбычнаяГруппа,
		Элементы.ГруппаДополнительныеРеквизиты);
	бг_ГруппаРеквизитыМагистраль.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	бг_ГруппаРеквизитыМагистраль.Заголовок = НСтр("ru = 'Реквизиты заявки ""Магистраль""'");
	
	бг_НомерЗаявкиМагистраль =
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_НомерЗаявкиМагистраль",
		бг_ГруппаРеквизитыМагистраль,
		"Объект.бг_НомерЗаявкиМагистраль",
		,
		,
		"ПолеНадписи");
	бг_НомерЗаявкиМагистраль.АвтоМаксимальнаяШирина = Ложь;
	бг_НомерЗаявкиМагистраль.МаксимальнаяШирина = 14;
	
	бг_СтатусЗаявкиМагистраль =
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_СтатусЗаявкиМагистраль",
		бг_ГруппаРеквизитыМагистраль,
		"Объект.бг_СтатусЗаявкиМагистраль",
		,
		,
		"ПолеНадписи");
	бг_СтатусЗаявкиМагистраль.АвтоМаксимальнаяШирина = Ложь;
	бг_СтатусЗаявкиМагистраль.МаксимальнаяШирина = 22;
	
	бг_УстановитьДоступностьРеквизитовМагистраль();
	
КонецПроцедуры

&НаСервере
Процедура бг_УстановитьДоступностьРеквизитовМагистраль()
	
	ДоговорАвтоматическиФормироватьЗаявкиНаРасходованиеДС = Ложь;
	Если Объект.РасшифровкаПлатежа.Количество() > 0 Тогда
		ОбъектРасчетов = Объект.РасшифровкаПлатежа[0].ОбъектРасчетов;
		Если ЗначениеЗаполнено(ОбъектРасчетов) Тогда
			ОбъектРасчетовДоговор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектРасчетов, "Договор");
			ДоговорАвтоматическиФормироватьЗаявкиНаРасходованиеДС =
				бг_Магистраль.АвтоматическиФормироватьЗаявкиНаРасходованиеДС(ОбъектРасчетовДоговор);
		КонецЕсли;
	КонецЕсли;
	
	ДоступностьРеквизитовМагистраль = Пользователи.РолиДоступны("бг_ДобавлениеИзменениеНастроекМагистраль")
		И ДоговорАвтоматическиФормироватьЗаявкиНаРасходованиеДС;
	
	Если Элементы.Найти("бг_ГруппаФакторМагистраль") <> Неопределено Тогда
		Элементы.бг_ГруппаФакторМагистраль.ТолькоПросмотр = Не ДоступностьРеквизитовМагистраль;
	КонецЕсли;
	
	Если Элементы.Найти("бг_ГруппаРеквизитыМагистраль") <> Неопределено Тогда
		Элементы.бг_ГруппаРеквизитыМагистраль.ТолькоПросмотр = Не ДоступностьРеквизитовМагистраль;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
