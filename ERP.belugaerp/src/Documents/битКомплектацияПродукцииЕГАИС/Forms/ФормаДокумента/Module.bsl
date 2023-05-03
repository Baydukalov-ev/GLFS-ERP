
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КомплектацияПродукцииЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
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
Процедура УстановитьПометкуУдаленияДокумента(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаленияДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТоварыПоШтрихкодамПоДаннымМарок(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Организация)
		Или Не ЗначениеЗаполнено(Объект.ОрганизацияЕГАИС) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнены данные организации'"),,, "Объект");
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	Если Не ВозможнаЗагрузкаИзВнешнегоФайла() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Штрихкоды.Количество() > 0 Тогда
		
		ОповещениеПоЗавершении = Новый ОписаниеОповещения(
			"ЗагрузитьИзВнешнегоФайлаПослеВопроса",
			ЭтотОбъект);
		
		ПоказатьВопрос(
			ОповещениеПоЗавершении,
			НСтр("ru='Заполненные штрихкоды будут очищены. Продолжить?'"),
			РежимДиалогаВопрос.ДаНет);
			
	Иначе
		ЗагрузитьИзВнешнегоФайлаОткрытиеФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайлаПослеВопроса(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьИзВнешнегоФайлаОткрытиеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайлаОткрытиеФормы()
	
	ОповещениеПослеЗакрытия = Новый ОписаниеОповещения("ЗагрузитьИзВнешнегоФайлаЗавершение", ЭтотОбъект);
	ПараметрыОткрытия = Новый Структура(
		"ОрганизацияЕГАИС, ДетализироватьРезультатДоМарок",
		Объект.ОрганизацияЕГАИС,
		Истина);
	
	ОткрытьФорму(
		"Обработка.бг_ЗаполнениеМарокИзТабличногоДокумента.Форма.Форма",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		ОповещениеПослеЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайлаЗавершение(Штрихкоды, ДополнительныеПараметры) Экспорт
	
	Если Не (ТипЗнч(Штрихкоды) = Тип("Массив") И Штрихкоды.Количество() > 0) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьШтрихкодыИзВнешнегоФайлаНаСервере(Штрихкоды);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСоздатьСертификацию(Команда)
	
	СтрокаТовары = Элементы.Товары.ТекущиеДанные;
	Если СтрокаТовары = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТовары.НоваяНоменклатура)
		Или Не ЗначениеЗаполнено(СтрокаТовары.НоваяСерия) Тогда

		Возврат;
	КонецЕсли;
	
	СертификацияНоменклатуры = СертификацияНоменклатуры(
		СтрокаТовары.НоваяНоменклатура,
		СтрокаТовары.НоваяСерия);
		
	Если ЗначениеЗаполнено(СертификацияНоменклатуры) Тогда
		
		ПоказатьЗначение(, СертификацияНоменклатуры);
		
	Иначе
		
		ПараметрыСертификации = Новый Структура;
		ПараметрыСертификации.Вставить("Номенклатура", СтрокаТовары.НоваяНоменклатура);
		ПараметрыСертификации.Вставить("Серия", СтрокаТовары.НоваяСерия);
		
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ПараметрыСертификации);
		ОткрытьФорму("Документ.битСертификацияНоменклатуры.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область Шапка

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.ОрганизацияЕГАИС = Неопределено;
	Иначе
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Конец Шапка

#Область Товары

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		ТекущаяСтрока.КодСтроки = НовыйКодСтрокиТовары(ЭтотОбъект);
		УстановитьОтборСтрокШтрихкодов(ТекущаяСтрока.КодСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтборСтрокШтрихкодов(ТекущаяСтрока.КодСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	УдалитьСвязанныеСТоваромШтрихкоды(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтараяНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	УдалитьСвязанныеСТоваромШтрихкоды(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтараяСерияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	УдалитьСвязанныеСТоваромШтрихкоды(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти // Конец Товары

#Область Штрихкоды

&НаКлиенте
Процедура ШтрихкодыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ВозможенВводаШтрихкода(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущаяСтрокаШтрихкоды = Элементы.Штрихкоды.ТекущиеДанные;
		
		ТекущаяСтрокаТовары = Элементы.Товары.ТекущиеДанные;
		
		ТекущаяСтрокаШтрихкоды.КлючСвязи = ТекущаяСтрокаТовары.КодСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодыШтрихкодПриИзменении(Элемент)
	
	ТекущаяСтрокаШтрихкоды = Элементы.Штрихкоды.ТекущиеДанные;
	ТекущаяСтрокаТовары = Элементы.Товары.ТекущиеДанные;
	
	ТекущаяСтрокаШтрихкоды.Штрихкод = СокрЛП(ТекущаяСтрокаШтрихкоды.Штрихкод);
	
	Если ПустаяСтрока(ТекущаяСтрокаШтрихкоды.Штрихкод) Или Не ВозможенВводаШтрихкода() Тогда
		ОчиститьДанныеВСтрокеШтрихкоды(ТекущаяСтрокаШтрихкоды, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	КонтекстЗаполненияДанныхТиповУпаковок = бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		ЭтаФорма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		ТекущаяСтрокаШтрихкоды,
		КонтекстЗаполненияДанныхТиповУпаковок);
		
	Если ТекущаяСтрокаШтрихкоды.ТипУпаковки <> ЗначенияТиповУпаковок.Бутылка Тогда
		
		ОчиститьДанныеВСтрокеШтрихкоды(ТекущаяСтрокаШтрихкоды, ЭтотОбъект);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Введите штрихкод марки (ввод штрихкодов коробок и паллет не поддерживается)'"));
			
	Иначе
		
		ШтрихкодыЗаполнитьТекущиеДанныеТоваровВСтроке(ТекущаяСтрокаШтрихкоды.ПолучитьИдентификатор());
		ЗаполнитьТипУпаковкиВСтрокеТаблицы(ТекущаяСтрокаШтрихкоды, ЭтотОбъект);
		ЗаполнитьТипУпаковкиРодителяВСтрокеТаблицы(ТекущаяСтрокаШтрихкоды, ЭтотОбъект);
		
		Если ТекущаяСтрокаШтрихкоды.СтараяНоменклатура <> ТекущаяСтрокаТовары.СтараяНоменклатура
			Или ТекущаяСтрокаШтрихкоды.СтараяСерия <> ТекущаяСтрокаТовары.СтараяСерия Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru='Данные штрихкода не совпадают с данными товара'"),,
				СтрШаблон("Штрихкоды[%1].Штрихкод", Формат(Объект.Штрихкоды.Индекс(ТекущаяСтрокаШтрихкоды), "ЧГ=0")),
				"Объект");
				
			ТекущаяСтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Некорректный;
			
		Иначе
			ТекущаяСтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Корректный;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // Конец Штрихкоды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	КартинкиТиповУпаковок = бг_МаркируемаяПродукция.КартинкиТиповУпаковок();
	ЗначенияТиповУпаковок = бг_МаркируемаяПродукция.ЗначенияТиповУпаковок();
	ДлиныШтрихкодовМарок = бг_МаркируемаяПродукция.ДлиныШтрихкодовМарок();
	СостоянияКорректностиШтрихкода = СостоянияКорректностиШтрихкода();
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ШтрихкодыЗаполнитьДанныеТиповУпаковок();
	ШтрихкодыЗаполнитьТекущиеДанныеТоваров();
	ШтрихкодыЗаполнитьДанныеТиповУпаковокРодителей();
	ШтрихкодыЗаполнитьСостоянияКорректностиШтрихкодов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСлужебныеРеквизиты();
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СостоянияКорректностиШтрихкода()
	
	СостоянияКорректностиШтрихкода = Новый Структура;
	
	СостоянияКорректностиШтрихкода.Вставить("Пустой", 0);
	СостоянияКорректностиШтрихкода.Вставить("Корректный", 1);
	СостоянияКорректностиШтрихкода.Вставить("Некорректный", 2);
	
	Возврат СостоянияКорректностиШтрихкода;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Основание) Тогда
		
		ОрганизацииЕГАИС = Справочники.КлассификаторОрганизацийЕГАИС.бг_ОрганизацииЕГАИСПоОрганизации(
			Объект.Организация,
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Основание, "Склад"));
			
		Если ОрганизацииЕГАИС.Количество() = 1 Тогда
			Объект.ОрганизацияЕГАИС = ОрганизацииЕГАИС[0];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ШтрихкодыЗаполнитьДанныеТиповУпаковок()
	
	КонтекстЗаполненияДанныхТиповУпаковокШтрихкод = КонтекстЗаполненияДанныхТиповУпаковок(ЭтотОбъект);
	
	Для каждого СтрокаШтрихкоды Из Объект.Штрихкоды Цикл
		
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаШтрихкоды,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкод);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ШтрихкодыЗаполнитьДанныеТиповУпаковокРодителей()
	
	КонтекстЗаполненияДанныхТиповУпаковокШтрихкодРодитель = КонтекстЗаполненияДанныхТиповУпаковокРодителя(ЭтотОбъект);
	
	Для каждого СтрокаШтрихкоды Из Объект.Штрихкоды Цикл
		
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			СтрокаШтрихкоды,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкодРодитель);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ШтрихкодыЗаполнитьСостоянияКорректностиШтрихкодов()
	
	Для каждого СтрокаТовары Из Объект.Товары Цикл
	
		СтрокиШтрихкодов = СвязанныеСТоварамиСтрокиШтрихкодов(ЭтотОбъект, СтрокаТовары);
		
		Для каждого СтрокаШтрихкоды Из СтрокиШтрихкодов Цикл
			
			Если ПустаяСтрока(СтрокаШтрихкоды.Штрихкод) Тогда
				
				СтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Пустой;
				
			ИначеЕсли СтрокаШтрихкоды.ТипУпаковки <> Перечисления.бг_ТипыЕдиницИзмерения.Бутылка Тогда
				
				СтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Некорректный;
				
			ИначеЕсли ЗначениеЗаполнено(СтрокаШтрихкоды.СтараяНоменклатура)
				И ЗначениеЗаполнено(СтрокаШтрихкоды.СтараяСерия)
				И СтрокаШтрихкоды.СтараяНоменклатура = СтрокаТовары.СтараяНоменклатура
				И СтрокаШтрихкоды.СтараяСерия = СтрокаТовары.СтараяСерия Тогда
				
				СтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Корректный;
				
			Иначе
				
				СтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Некорректный;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НовыйКодСтрокиТовары(Форма)
	
	МаксимальныйКодСтроки = 0;
	
	Для каждого СтрокаТовары Из Форма.Объект.Товары Цикл
		Если СтрокаТовары.КодСтроки > МаксимальныйКодСтроки Тогда
			МаксимальныйКодСтроки = СтрокаТовары.КодСтроки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МаксимальныйКодСтроки + 1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СвязанныеСТоварамиСтрокиШтрихкодов(Форма, СтрокаТовары)
	
	ПараметрыПоиска = Новый Структура("КлючСвязи", СтрокаТовары.КодСтроки);
	Возврат Форма.Объект.Штрихкоды.НайтиСтроки(ПараметрыПоиска);
	
КонецФункции

&НаКлиенте
Процедура УстановитьОтборСтрокШтрихкодов(КодСтроки)
	
	Элементы.Штрихкоды.ОтборСтрок = Неопределено;
	Элементы.Штрихкоды.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("КлючСвязи", КодСтроки));
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязанныеСТоваромШтрихкоды(СтрокаТовары)
	
	СвязанныеСтрокиШтрихкодов = СвязанныеСТоварамиСтрокиШтрихкодов(ЭтотОбъект, СтрокаТовары);
	
	Для каждого СтрокаШтрихкоды Из СвязанныеСтрокиШтрихкодов Цикл
		Объект.Штрихкоды.Удалить(СтрокаШтрихкоды);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ВозможенВводаШтрихкода(Отказ = Неопределено)
	
	Если Отказ = Неопределено Тогда
		Отказ = Ложь;
	КонецЕсли;
	
	ТекущаяСтрокаТовары = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущаяСтрокаТовары = Неопределено Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Введите товар, для которого указываете штрихкод'"),,
			"Товары",
			"Объект",
			Отказ);
			
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрокаТовары.СтараяНоменклатура)
		Или Не ЗначениеЗаполнено(ТекущаяСтрокаТовары.СтараяСерия) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Заполните номенклатуру и серию'"),,
			СтрШаблон("Товары[%1]", Формат(Объект.Товары.Индекс(ТекущаяСтрокаТовары), "ЧГ=0")),
			"Объект",
			Отказ);
			
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ОрганизацияЕГАИС) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Заполните организацию ЕГАИС'"),,
			"ОрганизацияЕГАИС",
			"Объект",
			Отказ);
			
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьДанныеВСтрокеШтрихкоды(СтрокаШтрихкоды, Форма)
	
	СтрокаШтрихкоды.Штрихкод = "";
	СтрокаШтрихкоды.ТипУпаковки = Неопределено;
	СтрокаШтрихкоды.КартинкаТипаУпаковки = Неопределено;
	СтрокаШтрихкоды.ШтрихкодРодитель = "";
	СтрокаШтрихкоды.ТипУпаковкиРодителя = Неопределено;
	СтрокаШтрихкоды.КартинкаТипаУпаковкиРодителя = Неопределено;
	СтрокаШтрихкоды.СтараяНоменклатура = Неопределено;
	СтрокаШтрихкоды.СтараяСерия = Неопределено;
	СтрокаШтрихкоды.СостояниеКорректностиШтрихкода = Форма.СостоянияКорректностиШтрихкода.Пустой;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьТипУпаковкиВСтрокеТаблицы(СтрокаТаблицы, Форма)
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		СтрокаТаблицы,
		КонтекстЗаполненияДанныхТиповУпаковок(Форма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьТипУпаковкиРодителяВСтрокеТаблицы(СтрокаТаблицы, Форма)
	
	бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
		СтрокаТаблицы,
		КонтекстЗаполненияДанныхТиповУпаковокРодителя(Форма));
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КонтекстЗаполненияДанныхТиповУпаковок(Форма)
	
	Возврат бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		Форма,
		"Штрихкод",
		"ТипУпаковки",
		"КартинкаТипаУпаковки");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КонтекстЗаполненияДанныхТиповУпаковокРодителя(Форма)
	
	Возврат бг_МаркируемаяПродукцияКлиентСервер.КонтекстЗаполненияДанныхТиповУпаковок(
		Форма,
		"ШтрихкодРодитель",
		"ТипУпаковкиРодителя",
		"КартинкаТипаУпаковкиРодителя");
	
КонецФункции

&НаСервере
Процедура ШтрихкодыЗаполнитьТекущиеДанныеТоваров()
	
	Документы.битКомплектацияПродукцииЕГАИС.ЗаполнитьТекущиеДанныеТоваровВШтрихкодах(
		Объект.Штрихкоды,
		Объект.ОрганизацияЕГАИС,
		ДатаПолученияТекущихДанныхШтрихкодов(),
		"СтараяНоменклатура, СтараяСерия, ШтрихкодРодитель");
	
КонецПроцедуры

&НаСервере
Процедура ШтрихкодыЗаполнитьТекущиеДанныеТоваровВСтроке(ИдентификаторСтрокиШтрихкоды)
	
	СтрокаШтрихкоды = Объект.Штрихкоды.НайтиПоИдентификатору(ИдентификаторСтрокиШтрихкоды);
	
	Документы.битКомплектацияПродукцииЕГАИС.ЗаполнитьТекущиеДанныеТовараВСтрокеШтрихкоды(
		СтрокаШтрихкоды,
		Объект.ОрганизацияЕГАИС,
		ДатаПолученияТекущихДанныхШтрихкодов(),
		"СтараяНоменклатура, СтараяСерия, ШтрихкодРодитель");
	
КонецПроцедуры

&НаСервере
Функция ДатаПолученияТекущихДанныхШтрихкодов()
	
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат Объект.Дата;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ВозможнаЗагрузкаИзВнешнегоФайла()
	
	ВозможнаЗагрузкаИзВнешнегоФайла = Истина;
	
	Если Не ЗначениеЗаполнено(Объект.ОрганизацияЕГАИС) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru='Не заполнена организация ЕГАИС.'"),,
			"ОрганизацияЕГАИС",
			"Объект");
		ВозможнаЗагрузкаИзВнешнегоФайла = Ложь;
	КонецЕсли;
	
	Если Объект.Товары.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнены товары.'"));
		ВозможнаЗагрузкаИзВнешнегоФайла = Ложь;
	КонецЕсли;
	
	Для каждого СтрокаТовары Из Объект.Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТовары.СтараяНоменклатура) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru='Не заполнена старая номенклатура.'"),,
				"Товары[" + Формат(Объект.Товары.Индекс(СтрокаТовары), "ЧГ=0") + "].СтараяНоменклатура",
				"Объект");
			ВозможнаЗагрузкаИзВнешнегоФайла = Ложь;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТовары.СтараяСерия) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru='Не заполнена старая серия.'"),,
				"Товары[" + Формат(Объект.Товары.Индекс(СтрокаТовары), "ЧГ=0") + "].СтараяСерия",
				"Объект");
			ВозможнаЗагрузкаИзВнешнегоФайла = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозможнаЗагрузкаИзВнешнегоФайла;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьШтрихкодыИзВнешнегоФайлаНаСервере(Штрихкоды)
	
	// Очищаем ТЧ "Штрихкоды".
	Объект.Штрихкоды.Очистить();
	
	// Подготавливаем таблицу штрихкодов к заполнению с предварительными проверками.
	ШтрихкодыКЗаполнению = Объект.Штрихкоды.Выгрузить();
	ШтрихкодыКЗаполнению.Очистить();
	
	Для каждого Штрихкод Из Штрихкоды Цикл
		ШтрихкодыКЗаполнению.Добавить().Штрихкод = Штрихкод;
	КонецЦикла;
	
	// Заполняем типы упаковок, чтобы отсеять штрихкоды, не являющиеся бутылками.
	КонтекстЗаполненияДанныхТиповУпаковокШтрихкод = КонтекстЗаполненияДанныхТиповУпаковок(ЭтотОбъект);
	
	Для каждого ДанныеШтрихкодаКЗаполнению Из ШтрихкодыКЗаполнению Цикл
		бг_МаркируемаяПродукцияКлиентСервер.ЗаполнитьДанныеТипаУпаковкиВСтрокеТаблицы(
			ДанныеШтрихкодаКЗаполнению,
			КонтекстЗаполненияДанныхТиповУпаковокШтрихкод);
	КонецЦикла;
	
	// Заполняем текущие данные товаров по штрихкодам для сопоставления с товарами в документе.
	Документы.битКомплектацияПродукцииЕГАИС.ЗаполнитьТекущиеДанныеТоваровВШтрихкодах(
		ШтрихкодыКЗаполнению,
		Объект.ОрганизацияЕГАИС,
		ДатаПолученияТекущихДанныхШтрихкодов(),
		"СтараяНоменклатура, СтараяСерия, ШтрихкодРодитель");
		
	// Заполняем штрихкоды в ТЧ с сопутствующими проверками.
	ОбработанныеШтрихкоды = Новый Массив;
	
	Для каждого ДанныеШтрихкодаКЗаполнению Из ШтрихкодыКЗаполнению Цикл
		
		Если ДанныеШтрихкодаКЗаполнению.ТипУпаковки <> Перечисления.бг_ТипыЕдиницИзмерения.Бутылка Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='Не является бутылкой штрихкод %1.'"),
					ДанныеШтрихкодаКЗаполнению.Штрихкод));
			Продолжить;
		КонецЕсли;
		
		Если ОбработанныеШтрихкоды.Найти(ДанныеШтрихкодаКЗаполнению.Штрихкод) <> Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='Дубль штрихкода %1.'"),
					ДанныеШтрихкодаКЗаполнению.Штрихкод));
			Продолжить;
		КонецЕсли;
		
		ПараметрыПоиска = Новый Структура("СтараяНоменклатура, СтараяСерия");
		ЗаполнитьЗначенияСвойств(ПараметрыПоиска, ДанныеШтрихкодаКЗаполнению);
		
		СтрокиТоваров = Объект.Товары.НайтиСтроки(ПараметрыПоиска);
		Если СтрокиТоваров.Количество() <> 1 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='Не найден соответствующий товар для штрихкода %1'"),
					ДанныеШтрихкодаКЗаполнению.Штрихкод));
		Иначе
			НоваяСтрокаШтрихкоды = Объект.Штрихкоды.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаШтрихкоды, ДанныеШтрихкодаКЗаполнению);
			ЗаполнитьЗначенияСвойств(НоваяСтрокаШтрихкоды, СтрокиТоваров[0]);
			НоваяСтрокаШтрихкоды.СостояниеКорректностиШтрихкода = СостоянияКорректностиШтрихкода.Корректный;
			НоваяСтрокаШтрихкоды.КлючСвязи = СтрокиТоваров[0].КодСтроки;
		КонецЕсли;
		
		ОбработанныеШтрихкоды.Добавить(ДанныеШтрихкодаКЗаполнению.Штрихкод);
	КонецЦикла;
	
	// Выполняем постобработку ТЧ "Штрихкоды".
	ШтрихкодыЗаполнитьДанныеТиповУпаковокРодителей();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СертификацияНоменклатуры(Номенклатура, Серия)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	битСертификацияНоменклатуры.Ссылка КАК СертификацияНоменклатуры
	|ИЗ
	|	Документ.битСертификацияНоменклатуры КАК битСертификацияНоменклатуры
	|ГДЕ
	|	битСертификацияНоменклатуры.Номенклатура = &Номенклатура
	|	И битСертификацияНоменклатуры.Серия = &Серия
	|	И НЕ битСертификацияНоменклатуры.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	битСертификацияНоменклатуры.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Серия", Серия);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СертификацияНоменклатуры;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
