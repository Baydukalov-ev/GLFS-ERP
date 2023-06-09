
&ИзменениеИКонтроль("ПриСозданииФормыЗначенияДоступа")
Процедура бг_ПриСозданииФормыЗначенияДоступа(Форма, ДополнительныеПараметры = Неопределено,
			УдалитьЭлементы = Неопределено, УдалитьТипЗначения = Неопределено, УдалитьСозданиеНового = Неопределено) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		Реквизит       = ДополнительныеПараметры.Реквизит;
		Элементы       = ДополнительныеПараметры.Элементы;
		ТипЗначения    = ДополнительныеПараметры.ТипЗначения;
		СозданиеНового = ДополнительныеПараметры.СозданиеНового;
	Иначе
		Реквизит       = ДополнительныеПараметры;
		Элементы       = УдалитьЭлементы;
		ТипЗначения    = УдалитьТипЗначения;
		СозданиеНового = УдалитьСозданиеНового;
	КонецЕсли;
	
	ЗаголовокОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка в процедуре %1
		           |общего модуля %2.';
		           |en = 'Error in procedure %1
		           |of common module %2.'"),
		"ПриСозданииФормыЗначенияДоступа",
		"УправлениеДоступом");
	
	Если ТипЗнч(СозданиеНового) <> Тип("Булево") Тогда
		Попытка
			ОбъектФормы = Форма.Объект; // ОпределяемыйТип.ЗначениеДоступа - реально ДанныеФормыСтруктура объекта.
			СозданиеНового = НЕ ЗначениеЗаполнено(ОбъектФормы.Ссылка);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Параметр %1 не указан, а автоматическое заполнение
				           |из реквизита формы ""%2"" недоступно по причине:
				           |%3';
				           |en = 'Parameter ""%1"" is required. Automatic filling
				           |from form attribute ""%2"" is not available. Reason:
				           |%3'"),
				"СозданиеНового",
				"Объект.Ссылка",
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
	КонецЕсли;
	
	Если ТипЗнч(ТипЗначения) <> Тип("Тип") Тогда
		Попытка
			ОбъектФормы = Форма.Объект; // ОпределяемыйТип.ЗначениеДоступа - реально ДанныеФормыСтруктура объекта.
			ТипЗначенияДоступа = ТипЗнч(ОбъектФормы.Ссылка);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Параметр %1 не указан, а автоматическое заполнение
				           |из реквизита формы ""%2"" недоступно по причине:
				           |%3';
				           |en = 'Parameter ""%1"" is required. Automatic filling
				           |from form attribute ""%2"" is not available. Reason:
				           |%3'"),
				"ТипЗначения",
				"Объект.Ссылка",
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
	Иначе
		ТипЗначенияДоступа = ТипЗначения;
	КонецЕсли;
	
	Если Элементы = Неопределено Тогда
		ЭлементыФормы = Новый Массив;
		ЭлементыФормы.Добавить("ГруппаДоступа");
		
	ИначеЕсли ТипЗнч(Элементы) <> Тип("Массив") Тогда
		ЭлементыФормы = Новый Массив;
		ЭлементыФормы.Добавить(Элементы);
	КонецЕсли;
	
	СвойстваГрупп = СвойстваГруппЗначенияДоступа(ТипЗначенияДоступа, ЗаголовокОшибки);
	
	Если Реквизит = Неопределено Тогда
		Попытка
			ГруппаЗначенийДоступа = Форма.Объект.ГруппаДоступа;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Параметр Реквизит не указан, а автоматическое заполнение
				           |из реквизита формы ""%2"" недоступно по причине:
				           |%3';
				           |en = 'Parameter ""Attribute"" is required. Cannot populate is automatically
				           |form attribute ""%2"" due to:
				           |%3'"),
				"Реквизит",
				"Объект.ГруппаДоступа",
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
	Иначе
		ПозицияТочки = СтрНайти(Реквизит, ".");
		Если ПозицияТочки = 0 Тогда
			Попытка
				ГруппаЗначенийДоступа = Форма[Реквизит];
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось получить значение реквизита формы ""%1"",
					           |указанного параметре %2 по причине:
					           |%3';
					           |en = 'Couldn''t get the value of form attribute ""%1""
					           |specified in parameter ""%2"". Reason:
					           |%3'"),
					Реквизит,
					"Реквизит",
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				ВызватьИсключение ТекстОшибки;
			КонецПопытки;
		Иначе
			Попытка
				ГруппаЗначенийДоступа = Форма[Лев(Реквизит, ПозицияТочки - 1)][Сред(Реквизит, ПозицияТочки + 1)];
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось получить значение реквизита формы ""%1"",
					           |указанного параметре %2 по причине:
					           |%3';
					           |en = 'Couldn''t get the value of form attribute ""%1""
					           |specified in parameter ""%2"". Reason:
					           |%3'"),
					Реквизит,
					"Реквизит",
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				ВызватьИсключение ТекстОшибки;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ГруппаЗначенийДоступа) <> СвойстваГрупп.Тип Тогда
		ТекстОшибки = ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для значений доступа типа ""%1""
			           |используются вид доступа ""%2"" с типом значений ""%3"",
			           |заданным в переопределяемом модуле.
			           |Но этот тип не совпадает с типом ""%4"" в форме значения
			           |доступа у реквизита %5.';
			           |en = 'The ""%2"" access kind
			           |with ""%3"" value type
			           |specified in the overridable module is used for access values of ""%1"" type.
			           |This type does not match the ""%4"" type of the %5 attribute
			           |in the access value form.'"),
			Строка(ТипЗначенияДоступа),
			Строка(СвойстваГрупп.ВидДоступа),
			Строка(СвойстваГрупп.Тип),
			Строка(ТипЗнч(ГруппаЗначенийДоступа)),
			"ГруппаДоступа");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Не УправлениеДоступомСлужебный.ВидДоступаИспользуется(СвойстваГрупп.ВидДоступа) Тогда
		Для Каждого Элемент Из ЭлементыФормы Цикл
			Форма.Элементы[Элемент].Видимость = Ложь;
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь( , , Ложь) Тогда
		Возврат;
	КонецЕсли;
#Вставка
	Если Форма.ИмяФормы = "Справочник.Партнеры.Форма.ФормаЭлемента"
		И Пользователи.РолиДоступны("ВводИнформацииПоПартнеруБезКонтроля", Пользователи.ТекущийПользователь()) Тогда
		Возврат;
	КонецЕсли;
#КонецВставки
	
	Если Не ПравоДоступа("Изменение", Метаданные.НайтиПоТипу(ТипЗначенияДоступа)) Тогда
		Форма.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;
	
	ГруппыЗначенийДляИзменения =
		ГруппыЗначенийДоступаРазрешающиеИзменениеЗначенийДоступа(ТипЗначенияДоступа);
	
	Если ГруппыЗначенийДляИзменения.Количество() = 0
	   И СозданиеНового Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для добавления требуются разрешенные ""%1"".';
				|en = 'Cannot add an item because this requires allowed ""%1"".'"),
			Метаданные.НайтиПоТипу(СвойстваГрупп.Тип).Представление());
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ГруппыЗначенийДляИзменения.Количество() = 0
	 ИЛИ НЕ СозданиеНового
	   И ГруппыЗначенийДляИзменения.Найти(ГруппаЗначенийДоступа) = Неопределено Тогда
		
		Форма.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;
	
	Если СозданиеНового
	   И НЕ ЗначениеЗаполнено(ГруппаЗначенийДоступа)
	   И ГруппыЗначенийДляИзменения.Количество() = 1 Тогда
		
		Если Реквизит = Неопределено Тогда
			Форма.Объект.ГруппаДоступа = ГруппыЗначенийДляИзменения[0];
		Иначе
			ПозицияТочки = СтрНайти(Реквизит, ".");
			Если ПозицияТочки = 0 Тогда
				Форма[Реквизит] = ГруппыЗначенийДляИзменения[0];
			Иначе
				Форма[Лев(Реквизит, ПозицияТочки - 1)][Сред(Реквизит, ПозицияТочки + 1)] = ГруппыЗначенийДляИзменения[0];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	НовыйПараметрВыбора = Новый ПараметрВыбора(
		"Отбор.Ссылка", Новый ФиксированныйМассив(ГруппыЗначенийДляИзменения));
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(НовыйПараметрВыбора);
	
	Для каждого Элемент Из ЭлементыФормы Цикл
		Форма.Элементы[Элемент].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	КонецЦикла;
	
КонецПроцедуры
